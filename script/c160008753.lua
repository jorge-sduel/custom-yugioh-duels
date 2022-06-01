--Queen of Bone Dragon
local cid,id=GetID()
function cid.initial_effect(c)
cid.IsEvolute=true
if not EVOLUTE_IMPORTED then Duel.LoadScript("proc_evolute.lua") end
	--c:EnableCounterPermit(0x88)
	c:EnableReviveLimit()
	Evolute.AddProcedure(c,nil,2,99,cid.rcheck)
end
function cid.rcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_DARK)
		and (g:IsExists(Card.IsRace,1,nil,RACE_ZOMBIE) or g:IsExists(Card.IsRace,1,nil,RACE_DRAGON))
end
