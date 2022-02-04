--Demon Claw Star-vader, Lanthanum
function c874.initial_effect(c)
	--Atk up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(874,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c874.atkcon)
	e1:SetOperation(c874.atkop)
	c:RegisterEffect(e1)
end
function c874.atkfilter(c,tp)
	return c:IsControler(1-tp) and c:IsFacedown()
end
function c874.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c874.atkfilter,1,nil,tp)
end
function c874.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(200)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end