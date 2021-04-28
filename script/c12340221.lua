--Fluid Reunion
function c12340221.initial_effect(c)
		c:EnableReviveLimit()
	--fusion material	
Fusion.AddProcFunRep(c,c12340221.ffilter,3,false)
	--to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12340221,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c12340221.shcon)
	e1:SetCost(c12340221.shcost)
	e1:SetTarget(c12340221.shtg)
	e1:SetOperation(c12340221.shop)
	c:RegisterEffect(e1)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340221,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c12340221.spcon)
	e2:SetCost(c12340221.spcost)
	e2:SetTarget(c12340221.sptg)
	e2:SetOperation(c12340221.spop)
	c:RegisterEffect(e2)
end
function c12340221.ffilter(c)
	return (c:IsSetCard(0x1204) or c:IsSetCard(0x204)) and c:IsLevelAbove(5)
	end
function c12340221.shcon(c)
	return Duel.IsExistingMatchingCard(c12340221.cfilter,tp,LOCATION_MZONE,0,1,nil)
        and Duel.IsExistingMatchingCard(c12340221.shfilter,tp,0,LOCATION_ONFIELD,1,nil)
end
function c12340221.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x204) and c:IsAbleToDeckAsCost()
end
function c12340221.shcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340221.cfilter,tp,LOCATION_MZONE,0,1,nil)
        and Duel.IsExistingTarget(c12340221.shfilter,tp,0,LOCATION_MZONE,1,e:GetHandler()) end
	local tc=Duel.SelectMatchingCard(tp,c12340221.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoDeck(tc,nil,0,REASON_COST)
end
function c12340221.shfilter(c)
	return c:IsAbleToDeck()
end
function c12340221.shtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	--if chkc then return chkc:IsOnField() and c12340221.shfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c12340221.shfilter,tp,0,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c12340221.shfilter,tp,0,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c12340221.shop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end

function c12340221.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c12340221.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
end
function c12340221.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function c12340221.spfilter(c,e,tp)
	return c:IsSetCard(0x204) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c12340221.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if e:GetHandler():GetSequence()<5 then ft=ft+1 end
	if chk==0 then return ft>0 and Duel.IsExistingMatchingCard(c12340221.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c12340221.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c12340221.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP) then
		tc:RegisterFlagEffect(tc:GetCode(),RESET_EVENT+0x16e0000,0,0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
		tc:CompleteProcedure()
	end
end