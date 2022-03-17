--Star-vader, Nebula Lord Dragon
function c854.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_DARK),Synchro.NonTunerEx(Card.IsSetCard,0x5DC),1,99)
	c:EnableReviveLimit()
	--cannot be destroyed
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--cannot be target effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c854.tgcon)
	e2:SetValue(c854.tgvalue)
	c:RegisterEffect(e2)
	--Limit Break
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(854,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(c854.atkcon)
	e3:SetTarget(c854.atktg)
	e3:SetValue(c854.atkval)
	c:RegisterEffect(e3)
	--Lock
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(854,1))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c854.target)
	e4:SetOperation(c854.operation)
	c:RegisterEffect(e4)
end
function c854.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c854.tgfilter,c:GetControler(),LOCATION_MZONE,0,2,nil)
end
function c854.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5DC)
end
function c854.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c854.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(e:GetHandlerPlayer())<4001
end
function c854.atktg(e,c)
	return c:IsType(TYPE_MONSTER) and (c:IsSetCard(0x5AA) or c:IsSetCard(0x5DC))
end
function c854.atkval(e,c)
	return Duel.GetMatchingGroupCount(c854.atkfilter,c:GetControler(),0,LOCATION_REMOVED,nil)*300
end
function c854.atkfilter(c)
	return c:IsFacedown()
end
function c854.filter(c)
	return c:IsAbleToRemove()
end
function c854.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c854.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c854.filter,tp,0,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c854.filter,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c854.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local seq=tc:GetSequence()
	if tc:IsLocation(LOCATION_MZONE) then seq=seq+16 end
	if tc:IsLocation(LOCATION_SZONE) then seq=seq+24 end
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT+REASON_TEMPORARY)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetLabel(seq)
		e1:SetLabelObject(tc)
		e1:SetCondition(c854.discon)
		e1:SetOperation(c854.disop)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		e2:SetLabelObject(tc)
		e2:SetCountLimit(1)
		e2:SetCondition(c854.recon)
		e2:SetOperation(c854.retop)
		Duel.RegisterEffect(e2,tp)	
	end
end
function c854.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c854.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c854.discon(e,c)
	if e:GetLabelObject():IsLocation(LOCATION_REMOVED) then return true end
	return false
end
function c854.disop(e,tp)
	local dis1=bit.lshift(0x1,e:GetLabel())
	return dis1
end
