--Star-vader, Freeze Ray Dragon
function c880.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x5DC),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--Lock
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(880,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetTarget(c880.tg)
	e1:SetOperation(c880.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_PAY_LPCOST)
	c:RegisterEffect(e2)
	--Atk up LB
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(880,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c880.atkcon)
	e3:SetOperation(c880.atkop)
	c:RegisterEffect(e3)
end
function c880.filter(c)
	return c:IsAbleToRemove()
end
function c880.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c880.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c880.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c880.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetChainLimit(c880.limit(g:GetFirst()))
end
function c880.limit(c)
	return	function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function c880.op(e,tp,eg,ep,ev,re,r,rp)
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
		e1:SetCondition(c880.discon)
		e1:SetOperation(c880.disop)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		e2:SetLabelObject(tc)
		e2:SetCountLimit(1)
		e2:SetCondition(c880.recon)
		e2:SetOperation(c880.retop)
		Duel.RegisterEffect(e2,tp)	
	end
end
function c880.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c880.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c880.discon(e,c)
	if e:GetLabelObject():IsLocation(LOCATION_REMOVED) then return true end
	return false
end
function c880.disop(e,tp)
	local dis1=bit.lshift(0x1,e:GetLabel())
	return dis1
end
function c880.atkfilter(c,tp)
	return c:IsControler(1-tp) and c:IsFacedown()
end
function c880.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c880.atkfilter,1,nil,tp) and Duel.GetLP(e:GetHandlerPlayer())<4001
end
function c880.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(300)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end