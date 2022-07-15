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
end
s.pendulum_level=10
