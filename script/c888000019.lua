--Volcano Guardian
function c888000019.initial_effect(c)
	--dark synchro summon
	c:EnableReviveLimit()
	Synchro.AddDarkSynchroProcedure(c,Synchro.NonTuner(nil),nil,3)
	--banish
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(888000019,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c888000019.cost)
	e2:SetTarget(c888000019.target)
	e2:SetOperation(c888000019.operation)
	c:RegisterEffect(e2)
	--banish (grave)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(888000019,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTarget(c888000019.bantg)
	e3:SetOperation(c888000019.banop)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(888000019,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(TIMING_STANDBY_PHASE)
	e4:SetCondition(c888000019.spcon)
	e4:SetTarget(c888000019.sptg)
	e4:SetOperation(c888000019.spop)
	c:RegisterEffect(e4)
	--indes
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_ADD_SETCODE)
	e6:SetValue(0x601)
	c:RegisterEffect(e6)
end
function c888000019.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c888000019.filter(c)
	return c:IsAbleToRemove()
end
function c888000019.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and c888000019.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c888000019.filter,tp,0,LOCATION_MZONE,1,nil) 
	and Duel.IsExistingTarget(c888000019.filter,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c888000019.filter,tp,0,LOCATION_MZONE,1,1,nil)
	local g2=Duel.SelectTarget(tp,c888000019.filter,tp,0,LOCATION_SZONE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g1,2,0,0)
end
function c888000019.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
end
function c888000019.banfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c888000019.bantg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c888000019.banfilter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,0,0)
end
function c888000019.banop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local hg=Duel.SelectMatchingCard(tp,c888000019.banfilter,tp,0,LOCATION_GRAVE,1,1,nil)
	if hg:GetCount()>0 then
		hg:AddCard(c)
		Duel.Remove(hg,POS_FACEUP,REASON_EFFECT)	
	end
end
function c888000019.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_STANDBY
end
function c888000019.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c888000019.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
