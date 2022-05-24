--Cosmicburst Dragon
local cid,id=GetID()
cid.IsSpacet=true
if not BIGBANG2_IMPORTED then Duel.LoadScript("proc_bigbang2.lua") end
function cid.initial_effect(c)
c:AddSetcodesRule(id,false,0xbb109)
	c:EnableReviveLimit()
	--.AddProcedure(c,cid.excon2,LOCATION_MZONE)
	Bigbang2.AddProcedure(c,cid.excon2,2,99)
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
function cid.excon2(e,c,tp)
	return c:IsAttackAbove(Duel.GetLP(tp)-e:GetAttack())
end
