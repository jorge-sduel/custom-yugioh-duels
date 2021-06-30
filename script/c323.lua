--last draw
local s,id=GetID()
function s.initial_effect(c)
	aux.EnableExtraRules(c,s,s.WorldStart)
end
function s.WorldStart()
	--disable field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_BECOME_LINKED_ZONE)
	e2:SetOperation(c323.disop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_BECOME_LINKED_ZONE)
	e3:SetValue(0x17)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_BECOME_LINKED_ZONE)
	e4:SetValue(0x08)
	c:RegisterEffect(e4)
end
