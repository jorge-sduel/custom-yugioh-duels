--Morhai Field
function c12340719.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add setcode
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetCode(EFFECT_ADD_SETCODE)
	e2:SetValue(0x209)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12340719,0))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c12340719.con)
	e3:SetTarget(c12340719.tg)
	e3:SetOperation(c12340719.op)
	c:RegisterEffect(e3)
	--banish & draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12340719,1))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetCondition(c12340719.drcon)
	e4:SetCost(c12340719.drcost)
	e4:SetTarget(c12340719.drtg)
	e4:SetOperation(c12340719.drop)
	c:RegisterEffect(e4)
end

function c12340719.cfilter(c,tp)
	return c:IsSetCard(0x209) and c:IsControler(tp)
end
function c12340719.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12340719.cfilter,1,nil,tp) and re and re:GetHandler():IsSetCard(0x209)
end
function c12340719.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=eg:Filter(c12340719.cfilter,nil):GetCount()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,ct) end
	if ct==0 then return false end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c12340719.op(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if d>0 and Duel.Draw(p,d,REASON_EFFECT)==d then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			if Duel.SelectOption(tp,aux.Stringid(12340719,2),aux.Stringid(12340719,3))==0 then
				Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
			else
				Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
			end
		end
	end
end

function c12340719.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
end
function c12340719.filter(c)
	return c:IsSetCard(0x209) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function c12340719.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340719.filter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c12340719.filter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c12340719.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c12340719.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end