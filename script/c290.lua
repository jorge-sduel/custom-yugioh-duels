--マシン
function c290.initial_effect(c)
	c:EnableCounterPermit(0x5f)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add counter
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetOperation(c290.ctop)
	c:RegisterEffect(e3)
	--send to grave
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(21521304,0))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(c290.atkcost)
	e4:SetTarget(c290.atktg)
	e4:SetOperation(c290.atkop)
	c:RegisterEffect(e4)
end
function c290.ctfilter(c)
	return c:IsPreviousLocation(LOCATION_MZONE)
end
function c290.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c290.ctfilter,1,nil)
end
function c290.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x5f,1)
end
function c290.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetCounter(0x5f)>0 and c:IsAbleToGraveAsCost() end
	e:SetLabel(c:GetCounter(0x5f))
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c290.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabel(0)
	Duel.SetTargetParam(ct)
end
function c290.atkop(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(ct*300)
		tc:RegisterEffect(e1)
	end
end
