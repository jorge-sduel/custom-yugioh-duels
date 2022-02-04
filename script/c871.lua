--Nightfall Star-vader, Darmstadtium
function c871.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--ATK up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(871,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c871.atcon)
	e2:SetValue(200)
	c:RegisterEffect(e2)
	--Break Ride
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(871,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c871.efcon)
	e3:SetOperation(c871.efop)
	c:RegisterEffect(e3)
end
function c871.atcon(e)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and e:GetHandler()==Duel.GetAttacker()
end
function c871.efcon(e,tp,eg,ep,ev,re,r,rp)
	return (r==REASON_XYZ or r==REASON_SYNCHRO) and Duel.GetLP(rp)<4001
end
function c871.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	rc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(871,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c871.cost)
	e2:SetTarget(c871.target)
	e2:SetOperation(c871.operation)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	rc:RegisterEffect(e2)
	if not rc:IsType(TYPE_EFFECT) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_ADD_TYPE)
		e3:SetValue(TYPE_EFFECT)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e3)
	end
end
function c871.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c871.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c871.cfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c871.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5DC) and c:GetLevel()>=7 and c:IsDiscardable()
end
function c871.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c871.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c871.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetChainLimit(aux.FALSE)
end
function c871.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c871.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	local tc1=g1:GetFirst()
	if tc1 then
		local seq=tc1:GetSequence()
		if tc1:IsLocation(LOCATION_MZONE) then seq=seq+16 end
		if tc1:IsLocation(LOCATION_SZONE) then seq=seq+24 end
		if tc1:IsRelateToEffect(e) then
		Duel.Remove(tc1,POS_FACEDOWN,REASON_EFFECT+REASON_TEMPORARY)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetLabel(seq)
		e1:SetLabelObject(tc1)
		e1:SetCondition(c871.discon)
		e1:SetOperation(c871.disop)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		e2:SetLabelObject(tc1)
		e2:SetCountLimit(1)
		e2:SetCondition(c871.recon)
		e2:SetOperation(c871.retop)
		Duel.RegisterEffect(e2,tp)
		end
	end
	local g2=Duel.SelectTarget(tp,c871.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	local tc2=g2:GetFirst()
	if tc2 then
		local seq=tc2:GetSequence()
		if tc2:IsLocation(LOCATION_MZONE) then seq=seq+16 end
		if tc2:IsLocation(LOCATION_SZONE) then seq=seq+24 end
		if tc2:IsRelateToEffect(e) then
		Duel.Remove(tc2,POS_FACEDOWN,REASON_EFFECT+REASON_TEMPORARY)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetLabel(seq)
		e1:SetLabelObject(tc2)
		e1:SetCondition(c871.discon)
		e1:SetOperation(c871.disop)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		e2:SetLabelObject(tc2)
		e2:SetCountLimit(1)
		e2:SetCondition(c871.recon)
		e2:SetOperation(c871.retop)
		Duel.RegisterEffect(e2,tp)	
		end
	end
	local g3=Duel.SelectTarget(tp,c871.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	local tc3=g3:GetFirst()
	if tc3 then
		local seq=tc3:GetSequence()
		if tc3:IsLocation(LOCATION_MZONE) then seq=seq+16 end
		if tc3:IsLocation(LOCATION_SZONE) then seq=seq+24 end
		if tc3:IsRelateToEffect(e) then
		Duel.Remove(tc3,POS_FACEDOWN,REASON_EFFECT+REASON_TEMPORARY)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetLabel(seq)
		e1:SetLabelObject(tc3)
		e1:SetCondition(c871.discon)
		e1:SetOperation(c871.disop)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		e2:SetLabelObject(tc3)
		e2:SetCountLimit(1)
		e2:SetCondition(c871.recon)
		e2:SetOperation(c871.retop)
		Duel.RegisterEffect(e2,tp)	
		end
	end
end
function c871.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c871.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetLabelObject(),REASON_EFFECT)
end
function c871.discon(e,c)
	if e:GetLabelObject():IsLocation(LOCATION_REMOVED) then return true end
	return false
end
function c871.disop(e,tp)
	local dis1=bit.lshift(0x1,e:GetLabel())
	return dis1
end