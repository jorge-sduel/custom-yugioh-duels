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
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DAMAGE)
	e4:SetCondition(s.drcon)
	e4:SetTarget(s.drtg)
	e4:SetOperation(s.drop)
	Duel.RegisterEffect(e4,0)
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetBattleDamage(tp)>=1000
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=math.floor(Duel.GetBattleDamage(tp)/1000)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct=math.floor(Duel.GetBattleDamage(tp)/1000)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Draw(p,ct,REASON_EFFECT)
end
