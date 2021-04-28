---External Worlds Counter
--Scripted by Secuter
function c12340016.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12340016,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c12340016.condition)
	e1:SetTarget(c12340016.target)
	e1:SetOperation(c12340016.effect)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340016,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,12340016+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c12340016.thcost)
	e2:SetTarget(c12340016.thtg)
	e2:SetOperation(c12340016.thop)
	c:RegisterEffect(e2)
end
function c12340016.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x201)
end
function c12340016.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c12340016.filter,tp,LOCATION_MZONE,0,1,nil) then return false end
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c12340016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c12340016.effect(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c12340016.tgfilter(c)
	return c:IsAbleToRemoveAsCost() and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end
function c12340016.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
        and Duel.IsExistingMatchingCard(c12340016.tgfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
    local g=Duel.SelectMatchingCard(tp,c12340016.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c12340016.thfilter(c)
	return c:IsSetCard(0x201) and c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function c12340016.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340016.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12340016.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12340016.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end