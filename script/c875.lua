--Furious Claw Star-vader, Niobium
function c875.initial_effect(c)
	--Atk up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(875,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c875.atkcon)
	e1:SetOperation(c875.atkop)
	c:RegisterEffect(e1)
end
function c875.atkfilter(c,tp)
	return c:IsControler(1-tp) and c:IsFacedown()
end
function c875.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c875.atkfilter,1,nil,tp)
end
function c875.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(200)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end