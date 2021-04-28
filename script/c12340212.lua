--Draw
function c12340212.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,12340212+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c12340212.cost)
	e1:SetTarget(c12340212.target)
	e1:SetOperation(c12340212.activate)
	c:RegisterEffect(e1)
end
function c12340212.filter(c)
	return c:IsSetCard(0x41) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function c12340212.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340212.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=Duel.SelectMatchingCard(tp,c12340212.filter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(tc,nil,2,REASON_COST)
end
function c12340212.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c12340212.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end