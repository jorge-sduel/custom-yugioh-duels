--Cosmicburst Dragon
local cid,id=GetID()
cid.IsSpacet=true
if not BIGBANG_IMPORTED then Duel.LoadScript("proc_bigbang.lua") end
function cid.initial_effect(c)
c:AddSetcodesRule(id,false,0xbb109)
	c:EnableReviveLimit()
	aux.AddSpacetSummonProcedure(c,cid.lcheck,LOCATION_MZONE,cid.excon)
	Bigbang.AddProcedure(c,nil,2,99,cid.excon2)
	--local e1=Effect.CreateEffect(c)
	--e1:SetType(EFFECT_TYPE_SINGLE)
	--e1:SetCode(52401238)
	--c:RegisterEffect(e1)
end
function cid.lcheck(c)
	return c:IsCode(52401237)
end
function cid.excon(e)
	return Duel.GetLP(e:GetHandlerPlayer())<=6000
end
function cid.excon2(e,g,lc,sumtype,tp)
	return g:IsExists(Card.IsAttackBelow,1,nil,Duel.GetLP(tp)+e:GetAttack())
end
