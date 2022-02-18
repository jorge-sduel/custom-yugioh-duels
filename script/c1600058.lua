--Mysterious Water Fairy
local s,id=GetID()
if not EVOLUTE_IMPORTED then Duel.LoadScript("proc_evolute.lua") end
function s.initial_effect(c)
	c:EnableReviveLimit()
	  --synchro summon
   Evolute.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_MONSTER),2,99)
end
