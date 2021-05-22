--クリアー・バイス・ドラゴン
function c329.initial_effect(c)
	c:EnableCounterPermit(0x1106)
	c:SetCounterLimit(0x1106,1)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26593852,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetTarget(c329.atktg)
	e1:SetOperation(c329.atkop)
	c:RegisterEffect(e1)
	--add counter
	local e3=Effect.CreateEffect(c)
e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PHASE_START+PHASE_END)
	e3:SetOperation(c329.ctop)
	c:RegisterEffect(e3)
end
function c329.ctop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,100100090) then return end
	e:GetHandler():AddCounter(0x1106,1)
end
