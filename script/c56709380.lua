--Nasca Line's Choosen Protector
function c56709380.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(56709380,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c56709380.con)
	e2:SetTarget(c56709380.tg)
	e2:SetOperation(c56709380.op)
	c:RegisterEffect(e2)
	--atk/def
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(56709380,1))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c56709380.atkcon)
	e3:SetOperation(c56709380.atkop)
	c:RegisterEffect(e3)
	--damage
	local e4=e3:Clone()
	e4:SetDescription(aux.Stringid(56709380,2))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCondition(c56709380.damcon)
	e4:SetTarget(c56709380.damtg)
	e4:SetOperation(c56709380.damop)
	c:RegisterEffect(e4)
end
function c56709380.gfilter(c,tp)
	return c:IsSetCard(0x21) and c:IsControler(tp)
end
function c56709380.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c56709380.gfilter,1,nil,tp)
end
function c56709380.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c56709380.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c56709380.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return c56709380.effcon(e,tp,eg,ep,ev,re,r,rp) and Duel.GetTurnPlayer()==tp
end
function c56709380.effilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x21) and c:IsControler(tp)
end
function c56709380.effcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c56709380.effilter,1,nil,tp)
end
function c56709380.atkfilter(c)
	return c:IsFaceup()
end
function c56709380.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c56709380.atkfilter,tp,0,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(-300)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end
function c56709380.damcon(e,tp,eg,ep,ev,re,r,rp)
	return c56709380.effcon(e,tp,eg,ep,ev,re,r,rp) and Duel.GetTurnPlayer()~=tp
end
function c56709380.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c56709380.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
