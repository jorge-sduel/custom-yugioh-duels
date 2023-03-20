--究極竜騎士
function c23061993.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcCode2(c,5405694,23061998,true,true)
local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c23061993.atkval)
	c:RegisterEffect(e1)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetCondition(c23061993.atkcon)
	e2:SetOperation(c23061993.atkop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(c23061993.indes)
	c:RegisterEffect(e3)
end
function c23061993.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function c23061993.atkval(e,c)
	return Duel.GetMatchingGroupCount(c23061993.filter,e:GetHandler():GetControler(),LOCATION_MZONE+LOCATION_GRAVE,LOCATION_GRAVE+LOCATION_MZONE,nil)*-500
end
function c23061993.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return a==c and d and d:IsFaceup() and d:GetAttack()>e:GetHandler():GetAttack()
end
function c23061993.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if tc:IsRelateToBattle() and c:IsRelateToBattle() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
		e1:SetValue(tc:GetAttack())
		c:RegisterEffect(e1)
	end
end
function c23061993.indes(e,c)
	return c:GetAttack()==e:GetHandler():GetAttack()
end
