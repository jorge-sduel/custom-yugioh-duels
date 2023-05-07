--Cosmicburst Dragon
local cid,id=GetID()
cid.IsSpacet=true
if not TIMESPACE_IMPORTED then Duel.LoadScript("proc_timespace.lua") end
function cid.initial_effect(c)
	aux.AddConvergentTSSummonProcedure(c,cid.lcheck,1,1,cid.lcheck2)
c:AddSetcodesRule(id,false,0xbb109)
	c:EnableReviveLimit()
	--.AddProcedure(c,cid.excon2,LOCATION_MZONE)
	--Timespace.AddProcedure(c,cid.excon2,1,1)
	--local e1=Effect.CreateEffect(c)
	--e1:SetType(EFFECT_TYPE_SINGLE)
	--e1:SetCode(52401238)
	--c:RegisterEffect(e1)
end
function cid.lcheck(c)
	return (c:IsCode(52401237) or c.IsBigbang)
end
function cid.lcheck2(g,lc,sumtype,tp)
	return g:IsExists(Card.IsAttackAbove,1,nil,Duel.GetLP(tp)-3500)
end
function cid.excon(e)
	return Duel.GetLP(e:GetHandlerPlayer())<=6000
end
function cid.excon2(e,c,tp)
	return --[[c:IsAttackAbove(Duel.GetLP(tp)-e:GetAttack()) and]]
c:IsCode(52401237) 
end
