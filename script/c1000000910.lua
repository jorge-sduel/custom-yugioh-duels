--Sin Selector
function c1000000910.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c1000000910.cost)
	e1:SetTarget(c1000000910.target)
	e1:SetOperation(c1000000910.activate)
	c:RegisterEffect(e1)
end
function c1000000910.cfilter(c)
	return c:IsSetCard(0x23) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c1000000910.filter(c)
	return c:IsSetCard(0x23) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c1000000910.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1000000910.cfilter,tp,LOCATION_GRAVE,0,2,nil) end
	local g=Duel.SelectMatchingCard(tp,c1000000910.cfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c1000000910.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c1000000910.filter,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c1000000910.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1000000910.filter,tp,LOCATION_DECK,0,2,2,nil)
	if g:GetCount()>1 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end