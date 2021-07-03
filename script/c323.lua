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
	--Lose counter
	local e4=Effect.GlobalEffect()
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DAMAGE)
	e4:SetOperation(s.ctxop)
	Duel.RegisterEffect(e4,0)
end
function s.ctxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if ep==1-tp then return end
	local ct=math.floor(ev/500)
	Duel.Draw(ep,ct, REASON_RULE)
end
