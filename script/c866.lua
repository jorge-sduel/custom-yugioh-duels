--Gravity Collapse Dragon
function c866.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x5DC)1,1,Synchro.NonTunerEx(nil),1,99)
	c:EnableReviveLimit()
	--Lock
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(866,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c866.condition)
	e1:SetTarget(c866.target)
	e1:SetOperation(c866.operation)
	c:RegisterEffect(e1)
	--ATK up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(866,1))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c866.atkcon)
	e2:SetValue(100)
	c:RegisterEffect(e2)
end
function c866.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
	and Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandler():GetControler(),LOCATION_GRAVE,0,1,nil,864)
end
function c866.filter(c)
	return c:IsAbleToRemove()
end
function c866.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c866.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c866.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c866.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetChainLimit(c866.limit(g:GetFirst()))
end
function c866.limit(c)
	return	function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function c866.operation(e,tp,eg,ep,ev,re,r,rp)
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
		e1:SetCondition(c866.discon)
		e1:SetOperation(c866.disop)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		e2:SetLabelObject(tc)
		e2:SetCountLimit(1)
		e2:SetCondition(c866.recon)
		e2:SetOperation(c866.retop)
		Duel.RegisterEffect(e2,tp)	
	end
end
function c866.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c866.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c866.discon(e,c)
	if e:GetLabelObject():IsLocation(LOCATION_REMOVED) then return true end
	return false
end
function c866.disop(e,tp)
	local dis1=bit.lshift(0x1,e:GetLabel())
	return dis1
end
function c866.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(Card.IsCode,c:GetControler(),LOCATION_GRAVE,0,1,nil,865)
end
