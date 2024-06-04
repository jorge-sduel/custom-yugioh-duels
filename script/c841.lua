--Starve
local s,id=GetID() 
function s.initial_effect(c)
		c:EnableReviveLimit()
	--fusion material	
	Fusion.AddProcMixN(c,true,true,s.ffilter,3)
	--defense attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end

function s.ffilter(c)
	return c:IsSetCard(0x2066)
end
