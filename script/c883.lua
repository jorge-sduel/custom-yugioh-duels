--Binary Star Twin Gunner
function c883.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,8,2)
	c:EnableReviveLimit()
	--Overlay Charge
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(883,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCost(c883.ovcost)
	e1:SetOperation(c883.ovop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e2)
	--Lock Limit Break
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(883,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c883.condition)
	e3:SetCost(c883.cost)
	e3:SetTarget(c883.target)
	e3:SetOperation(c883.operation)
	c:RegisterEffect(e3)
end
function c883.ovcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
	return Duel.IsExistingMatchingCard(c883.ovfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,e:GetHandler()) end
end
function c883.ovfilter(c,e,tp,eg,ep,ev,re,r,rp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5DC)
end
function c883.ovop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c883.ovfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,e:GetHandler()) then return end
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c883.ovfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,c)
	local tc=g:GetFirst()
	if tc and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
		local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        e1:SetValue(500)
        c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_PIERCE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end
function c883.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(e:GetHandlerPlayer())<4001
end
function c883.cfilter(c)
	return c:IsSetCard(0x5DC) and c:IsAbleToRemoveAsCost() 
end
function c883.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c883.filter(c)
	return c:IsAbleToRemove()
end
function c883.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c883.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c883.filter,tp,0,LOCATION_MZONE,1,nil) 
	and Duel.IsExistingTarget(c883.filter,tp,0,LOCATION_SZONE,1,nil) end
	Duel.SetChainLimit(aux.FALSE)
end
function c883.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c883.filter,tp,0,LOCATION_MZONE,1,1,nil)
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
		e1:SetCondition(c883.discon)
		e1:SetOperation(c883.disop)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		e2:SetLabelObject(tc1)
		e2:SetCountLimit(1)
		e2:SetCondition(c883.recon)
		e2:SetOperation(c883.retop)
		Duel.RegisterEffect(e2,tp)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,c883.filter,tp,0,LOCATION_SZONE,1,1,nil)
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
		e1:SetCondition(c883.discon)
		e1:SetOperation(c883.disop)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		e2:SetLabelObject(tc2)
		e2:SetCountLimit(1)
		e2:SetCondition(c883.recon)
		e2:SetOperation(c883.retop)
		Duel.RegisterEffect(e2,tp)	
		end
	end
end
function c883.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c883.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c883.discon(e,c)
	if e:GetLabelObject():IsLocation(LOCATION_REMOVED) then return true end
	return false
end
function c883.disop(e,tp)
	local dis1=bit.lshift(0x1,e:GetLabel())
	return dis1
end
