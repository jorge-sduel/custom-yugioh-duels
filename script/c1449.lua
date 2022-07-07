--Extra ritual trap
local s,id=GetID()
if not REVERSEPENDULUM_IMPORTED then Duel.LoadScript("proc_reverse_pendulum.lua") end
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
end
s.pendulum_level=10
