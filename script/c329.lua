--クリアー・バイス・ドラゴン
function c329.initial_effect(c)
	c:EnableCounterPermit(0x1106)
	c:SetCounterLimit(0x1106,1)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c329.atkcon)
	e1:SetValue(c329.atkval)
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
	e3:SetOperation(c329.ctop)
	c:RegisterEffect(e3)
end
function c329.atkcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL
		and e:GetHandler()==Duel.GetAttacker() and Duel.GetAttackTarget()~=nil
end
function c329.atkval(e,c)
	return Duel.GetAttackTarget():GetAttack()
end
function c329.ctop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,100100090) then return end
	e:GetHandler():AddCounter(0x1106,1)
end
function c329.dfilter(c)
	return not c:IsReason(REASON_REPLACE) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and (c:IsCode(330) or c:IsCode(331) or c:IsCode(332))
end
function c329.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local count=eg:FilterCount(c329.dfilter,nil)
		e:SetLabel(count)
		return count>0 and Duel.IsCanRemoveCounter(tp,1,0,0x1106,count,REASON_COST)
	end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c329.value(e,c)
	return c:IsFaceup() and c:GetLocation()==LOCATION_MZONE and (c:IsCode(330) or c:IsCode(331) or c:IsCode(332))
end
function c329.desop(e,tp,eg,ep,ev,re,r,rp)
	local count=e:GetLabel()
	Duel.RemoveCounter(tp,1,0,0x1106,count,REASON_COST)
end

