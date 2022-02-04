--Star-vader, "Reverse" Cradle
function c851.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(851,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c851.spcon)
	c:RegisterEffect(e1)
	--Lock Limit Break
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(851,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c851.condition)
	e2:SetCost(c851.cost)
	e2:SetTarget(c851.target)
	e2:SetOperation(c851.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c851.spfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5AA)
end
function c851.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and	Duel.IsExistingMatchingCard(c851.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c851.zfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x5AA) and c:IsType(TYPE_MONSTER) and c:IsControler(tp)
end
function c851.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:FilterCount(c851.zfilter,nil,tp)>0 and Duel.GetLP(e:GetHandlerPlayer())<4001
end
function c851.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(851)==0 end
	e:GetHandler():RegisterFlagEffect(851,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c851.filter(c)
	return c:IsAbleToRemove()
end
function c851.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c851.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c851.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c851.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetChainLimit(c851.limit(g:GetFirst()))
end
function c851.limit(c)
	return	function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function c851.operation(e,tp,eg,ep,ev,re,r,rp)
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
		e1:SetCondition(c851.discon)
		e1:SetOperation(c851.disop)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		e2:SetLabelObject(tc)
		e2:SetCountLimit(1)
		e2:SetCondition(c851.recon)
		e2:SetOperation(c851.retop)
		Duel.RegisterEffect(e2,tp)	
	end
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c851.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c851.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c851.discon(e,c)
	if e:GetLabelObject():IsLocation(LOCATION_REMOVED) then return true end
	return false
end
function c851.disop(e,tp)
	local dis1=bit.lshift(0x1,e:GetLabel())
	return dis1
end