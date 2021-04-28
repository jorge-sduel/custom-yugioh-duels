--Dark Whirlwind
function c888000022.initial_effect(c)
	--dark synchro summon
	c:EnableReviveLimit()
	Synchro.AddDarkSynchroProcedure(c,Synchro.NonTuner(nil),nil,4)
	--synchro summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(888000022,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c888000022.spcon)
	e2:SetTarget(c888000022.sptg)
	e2:SetOperation(c888000022.spop)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(888000022,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLED)
	e3:SetCondition(c888000022.condition)
	e3:SetOperation(c888000022.operation)
	c:RegisterEffect(e3)
end
function c888000022.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c888000022.filter(c)
	return c:IsAbleToDeck() 
end
function c888000022.senfilter(c,tp)
	return c:IsLocation(LOCATION_ONFIELD)
end
function c888000022.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,nil)
	local sg=Duel.GetMatchingGroup(c888000022.filter,tp,LOCATION_GRAVE,0,nil)
	local send=Duel.GetMatchingGroup(c888000022.senfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,send,send:GetCount(),0,0)
end
function c888000022.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,nil)
	local sg=Duel.GetMatchingGroup(c888000022.filter,tp,LOCATION_GRAVE,0,nil)
	local send=Duel.GetMatchingGroup(c888000022.senfilter,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()==0 and sg:GetCount()==0 and send:GetCount()==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.SendtoDeck(sg,nil,sg:GetCount(),REASON_EFFECT)
	Duel.SendtoGrave(send,REASON_EFFECT)
end
function c888000022.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	local bc=c:GetBattleTarget()
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED) and not bc:IsType(TYPE_TOKEN) and bc:GetLeaveFieldDest()==0
end
function c888000022.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_SEND_REPLACE)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetTarget(c888000022.reptg)
		e1:SetOperation(c888000022.repop)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
		bc:RegisterEffect(e1)
	end
end
function c888000022.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetDestination()==LOCATION_GRAVE and c:IsReason(REASON_BATTLE) end
	return true
end
function c888000022.repop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_EFFECT)>0 then
		if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 then
			local g=Duel.GetFieldGroup(1-tp,0,LOCATION_HAND)
			if g:GetCount()>0 then
				Duel.ConfirmCards(tp,g)
				local sg=g:Select(1-tp,1,1,nil)
				Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
				Duel.ShuffleHand(tp)
			end
		end
	end
end
