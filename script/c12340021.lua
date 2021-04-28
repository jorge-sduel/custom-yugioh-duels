--Cards
function c12340021.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,12340021+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c12340021.cost)
	e1:SetTarget(c12340021.target)
	e1:SetOperation(c12340021.activate)
	c:RegisterEffect(e1)
end
function c12340021.filter(c)
	return c:IsSetCard(0x201) and c:IsAbleToGraveAsCost()
end
function c12340021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local h=1
	if e:GetHandler():IsLocation(LOCATION_HAND) then h=h+1 end
	if chk==0 then return Duel.IsExistingMatchingCard(c12340021.filter,tp,LOCATION_HAND,0,h,nil)
        and Duel.IsExistingMatchingCard(c12340021.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c12340021.filter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	local g=Duel.SelectMatchingCard(tp,c12340021.filter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c12340021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340021.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12340021.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12340021.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end