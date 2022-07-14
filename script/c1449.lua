--Extra ritual trap
local s,id=GetID()
if not REVERSEPENDULUM_IMPORTED then Duel.LoadScript("proc_reverse_pendulum.lua") end
if not TRAMPULA_IMPORTED then Duel.LoadScript("proc_trampula.lua") end
function s.initial_effect(c)
   RPendulum.AddProcedure(c)
c:AddSetcodesRule(id,false,0xbb00)
Ritual.AddProcGreater(c)
		local ea=Effect.CreateEffect(c)
 		ea:SetDescription(69,1)
 		ea:SetType(EFFECT_TYPE_IGNITION)
 		ea:SetRange(LOCATION_HAND)
 		ea:SetOperation(Trampula.SetOp)
 		c:RegisterEffect(ea)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_PENDULUM))
	e2:SetValue(500)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(s.atkcon)
	e3:SetOperation(s.atkop)
	c:RegisterEffect(e3)
end
s.pendulum_level=10
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return Duel.GetAttackTarget()==nil and at:Iscontroler(1-tp)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
