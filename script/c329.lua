--クリアー・バイス・ドラゴン
function c329.initial_effect(c)
	c:EnableCounterPermit(0x1106)
	c:SetCounterLimit(0x1106,1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SET_ATTACK)

	e2:SetValue(c329.atkval)
	c:RegisterEffect(e2)
	--add counter
	local e3=Effect.CreateEffect(c)
e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PHASE_START+PHASE_END)
	e3:SetOperation(c329.ctop)
	c:RegisterEffect(e3)
end
function c329.condtion(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL
		and Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()~=nil
end
function c329.atkval(e,c)
	return Duel.GetAttackTarget():GetAttack()
end
function c329.ctop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,100100090) then return end
	e:GetHandler():AddCounter(0x1106,1)
end
