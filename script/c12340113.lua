--Spell
function c12340113.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,12340113+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c12340113.cost)
	e1:SetTarget(c12340113.target)
	e1:SetOperation(c12340113.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340113,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c12340113.thcost)
	e2:SetOperation(c12340113.thop)
	c:RegisterEffect(e2)
end

function c12340113.costfilter(c)
	return (c:IsAttackBelow(0) or c:IsDefenseBelow(0)) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c12340113.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340113.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c12340113.costfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c12340113.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c12340113.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

function c12340113.thfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckOrExtraAsCost()
end
function c12340113.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340113.thfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c12340113.thfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c12340113.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end