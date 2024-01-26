--超巨大空中宮殿ガンガリディア
--Skypalace Gangaridai
local s,id=GetID()
s.Is_Cosmic=true
function s.initial_effect(c)
	--Xyz Summon
	Xyz.AddProcedure(c,nil,9,2)
	c:EnableReviveLimit()
	--Destroy 1 of opponent's cards, and if you do, inflict 1200 damage
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(aux.dxmcostgen(1,1,nil))
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1,false,REGISTER_FLAG_DETACH_XMAT)
	--Special summon itself from GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,{id,1})
	e2:SetCondition(s.condition)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	c:RegisterEffect(e2)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1200)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.Remove(tc,POS_FACEUP,REASON_COST)==0 then return end
	Duel.Damage(1-tp,1200,REASON_EFFECT)
end
function s.spfilter(c)
	return c.Is_Cosmic and c:IsType(TYPE_LINK)
end
function s.spfilter2(c)
	return c.Is_Cosmic
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_MZONE,0,1,nil) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		if Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			local cd=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_REMOVED,0,1,1,nil):GetFirst()
			Duel.BreakEffect()
			Duel.Overlay(e:GetHandler(),cd)
		end
	end
end
