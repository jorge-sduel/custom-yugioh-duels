--ESPergear Knight: Swordie
local cid,id=GetID()
function cid.initial_effect(c)
cid.IsEvolute=true
if not EVOLUTE_IMPORTED then Duel.LoadScript("proc_evolute.lua") end
function cid.initial_effect(c)
	c:EnableReviveLimit()
	Evolute.AddProcedure(c,nil,2,2) 
end
