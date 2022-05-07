--Cosmicburst Dragon
local cid,id=GetID()
cid.IsSpacet=true
if not BIGBANG_IMPORTED then Duel.LoadScript("proc_bigbang.lua") end
function cid.initial_effect(c)
c:AddSetcodesRule(id,false,0xbb109)
	c:EnableReviveLimit()
		aux.AddSpacetSummonProcedure(c,52401237,LOCATION_MZONE)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(52401238)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(-1500)
	c:RegisterEffect(e2)
end
