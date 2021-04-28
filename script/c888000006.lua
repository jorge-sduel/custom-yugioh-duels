--Evil HERO Volcano
function c888000006.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcCode2(c,98266377,95362816,true,true)
	--lizard check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(CARD_CLOCK_LIZARD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(c888000006.lizcon)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--Special Summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.EvilHeroLimit)
	c:RegisterEffect(e1)
	--ATK Up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c888000006.atktg)
	e3:SetValue(1000)
	c:RegisterEffect(e3)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c888000006.atkcon)
	e1:SetOperation(c888000006.atkop)
	c:RegisterEffect(e1)
end
c888000006.material_setcode={0x8,0x3008}
c888000006.dark_calling=true
c888000006.listed_names={CARD_DARK_FUSION,58932615,21844576}
function c888000006.lizcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),EFFECT_SUPREME_CASTLE)
end
function c888000006.atktg(e,c)
	return c:IsRace(RACE_FIEND)
end
function c888000006.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a:GetControler()==tp and a:IsRelateToBattle() and d and d:GetAttack()~=d:GetBaseAttack())
		or (d and d:GetControler()==tp and d:IsRelateToBattle() and a:GetAttack()~=a:GetBaseAttack())
end
function c888000006.atkop(e,tp,eg,ep,ev,re,r,rp)
	local atk=0
	local bc
	if e:GetHandler()==Duel.GetAttacker() then
		bc=Duel.GetAttackTarget()
	else
		bc=Duel.GetAttacker()
	end
	if(bc:GetBaseAttack()>bc:GetAttack()) then
		atk=bc:GetBaseAttack()-bc:GetAttack()
	else
		atk=bc:GetAttack()-bc:GetBaseAttack()
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(bc:GetBaseAttack())
	bc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	e2:SetValue(atk)
	e:GetHandler():RegisterEffect(e2)
end
