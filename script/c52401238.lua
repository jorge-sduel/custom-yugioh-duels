--Cosmicburst Dragon
local cid,id=GetID()
cid.IsSpacet=true
if not BIGBANG_IMPORTED then Duel.LoadScript("proc_bigbang.lua") end
function cid.initial_effect(c)
c:AddSetcodesRule(id,false,0xbb109)
	c:EnableReviveLimit()
	aux.AddSpacetSummonProcedure(c,nil,LOCATION_MZONE,cid.lcheck)
	--local e1=Effect.CreateEffect(c)
	--e1:SetType(EFFECT_TYPE_SINGLE)
	--e1:SetCode(52401238)
	--c:RegisterEffect(e1)
end
function cid.lcheck(g,lc,sumtype,tp)
 --local rc=e:GetHandler()
 --local tp=e:GetControler()
	return g:IsExists(Card.IsCode,1,nil,52401237) and g:IsAttackBelow(3500-Duel.GetLP(e:GetHandlerPlayer()))
end
