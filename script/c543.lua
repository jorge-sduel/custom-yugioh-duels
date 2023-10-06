--
local s,id=GetID()
s.Is_Neutrino=true
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Fusion material
	Fusion.AddProcMixN(c,true,true,s.matfilter,3)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
		--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK))
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--Def
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTarget(aux.FaceupFilter(Card.IsAttributeExcept,ATTRIBUTE_DARK)
	e3:SetValue(-1000)
	c:RegisterEffect(e3)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
end
function s.matfilter(c)
	return c.Is_Neutrino and c:IsRace(RACE_WARRIOR)
end
function s.val1(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function s.val(c)
	return not c:IsAttribute(ATTRIBUTE_DARK)
end
