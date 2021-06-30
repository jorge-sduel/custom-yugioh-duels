--Master Rule 3.5
local s,id=GetID()
function s.initial_effect(c)
	aux.EnableExtraRules(c,s,s.WorldStart)
end
function s.WorldStart()
	local e3=Effect.GlobalEffect()
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_BECOME_LINKED_ZONE)
	e3:SetValue(0xffffff)
	Duel.RegisterEffect(e3,0)
end
