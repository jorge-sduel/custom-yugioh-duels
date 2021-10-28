--クリアー・バイス・ドラゴン
function c331.initial_effect(c)
	c:EnableCounterPermit(0x1106)
	c:SetCounterLimit(0x1106,1)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c331.atkcon)
	e1:SetValue(c331.atkval)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c329.destg)
	e2:SetValue(c329.value)
	e2:SetOperation(c329.desop)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PHASE_START+PHASE_END)
	e3:SetCondition(c329.ctcon)
	e3:SetOperation(c331.ctop)
	c:RegisterEffect(e3)
end
function c331.atkcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL
		and e:GetHandler()==Duel.GetAttacker() and Duel.GetAttackTarget()~=nil
end
function c331.atkval(e,c)
	return Duel.GetAttackTarget():GetAttack()
end
function c331.ctop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,100100090) then return end
	e:GetHandler():AddCounter(0x1106,1)
end
