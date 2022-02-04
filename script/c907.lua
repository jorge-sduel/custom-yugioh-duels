--Silver Thorn Dragon Queen, Luquier "Reverse"
function c907.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.XyzFilterFunction(c,8),2)
	c:EnableReviveLimit()
	--cannot be destroyed
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--Cross Ride
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c907.atkcon)
	e2:SetValue(200)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c907.atkcon)
	e3:SetValue(c907.tgvalue)
	c:RegisterEffect(e3)
	--Limit Break
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(907,0))
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetHintTiming(0,TIMING_STANDBY_PHASE+0x1c0)
	e4:SetCondition(c907.condition)
	e4:SetCost(c907.cost)
	e4:SetTarget(c907.target)
	e4:SetOperation(c907.operation)
	c:RegisterEffect(e4)
end
function c907.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,906)
end
function c907.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c907.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(e:GetHandlerPlayer())<4001
end
function c907.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(907)==0 
	and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
	c:RegisterFlagEffect(907,RESET_EVENT+0x1fe0000+RESET_CHAIN,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g1=Duel.SelectTarget(tp,c907.cfilter,tp,LOCATION_MZONE,0,1,1,c)
	local tc1=g1:GetFirst()
	if tc1 then
		local seq=tc1:GetSequence()
		Duel.Remove(tc1,POS_FACEDOWN,REASON_COST+REASON_TEMPORARY)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabel(seq)
		e1:SetLabelObject(tc1)
		e1:SetCondition(c907.discon)
		e1:SetOperation(c907.disop)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetLabelObject(tc1)
		e2:SetCountLimit(1)
		e2:SetOperation(c907.retop)
		Duel.RegisterEffect(e2,tp)	
	end
end
function c907.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c907.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(c907.cfilter,tp,LOCATION_MZONE,0,1,c)
		and Duel.IsExistingMatchingCard(c907.spfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
end
function c907.spfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:GetOverlayCount()>0
	and c:GetOverlayGroup():IsExists(c907.spfilter2,1,nil)
end
function c907.spfilter2(c)
	return c:IsType(TYPE_MONSTER)
end
function c907.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 
	or not Duel.IsExistingMatchingCard(c907.spfilter,tp,LOCATION_MZONE,0,1,nil) then return end
	local g=Duel.SelectMatchingCard(tp,c907.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	local g1=tc:GetOverlayGroup()
	local sg=g1:FilterSelect(tp,c907.spfilter2,1,1,nil)
	local tc1=sg:GetFirst()
	if tc1 then
		Duel.SpecialSummon(tc1,0,tp,tp,true,true,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc1:RegisterEffect(e1)
	end
end
function c907.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c907.discon(e,c)
	if e:GetLabelObject():IsLocation(LOCATION_REMOVED) then return true end
	return false
end
function c907.disop(e,tp)
	local dis1=bit.lshift(0x1,e:GetLabel())
	return dis1
end