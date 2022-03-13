--ESPergear Knight: Swordie
local cid,id=GetID()
function cid.initial_effect(c)
cid.IsEvolute=true
if not EVOLUTE_IMPORTED then Duel.LoadScript("proc_evolute.lua") end
function cid.initial_effect(c)
	c:EnableReviveLimit()
	Evolute.AddProcedure(c,cid.matfilter,2,2,cid.rcheck) 
end
function cid.matfilter(c,ec,tp)
   return c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsRace(RACE_MACHINE)
end
function cid.rcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_LIGHT)
		and g:IsExists(Card.IsRace,1,nil,RACE_MACHINE)
end

