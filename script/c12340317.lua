--Spell
function c12340317.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c12340317.filter)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--Def
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c12340317.filter)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
end

function c12340317.filter(e,c)
    return c:IsType(TYPE_RITUAL)
end