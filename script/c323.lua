--last draw
local s,id=GetID()
function s.initial_effect(c)
	aux.EnableExtraRules(c,s,s.WorldStart)
end
function s.WorldStart()
	local e3=Effect.GlobalEffect()
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_BECOME_LINKED_ZONE)
	e3:SetValue(0x17)
	Duel.RegisterEffect(e3,0)
	local e4=Effect.GlobalEffect()
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_BECOME_LINKED_ZONE)
	e4:SetValue(0x08)
	Duel.RegisterEffect(e4,0)
end
