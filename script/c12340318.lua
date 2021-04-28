--Spell
function c12340318.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,12340318+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c12340318.cost)
	e1:SetTarget(c12340318.target)
	e1:SetOperation(c12340318.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340318,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,12340318+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c12340318.thcost)
	e2:SetTarget(c12340318.thtg)
	e2:SetOperation(c12340318.thop)
	c:RegisterEffect(e2)
end

function c12340318.costfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsDiscardable()
end
function c12340318.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340318.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c12340318.costfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c12340318.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340318.filter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12340318.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12340318.filter,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		local mg=Duel.GetMatchingGroup(c12340318.filter2,tp,LOCATION_DECK,0,nil,g:GetFirst())
		if mg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=mg:Select(tp,1,1,nil)
			g:Merge(sg)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c12340318.filter(c,tp)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
		and Duel.IsExistingMatchingCard(c12340318.filter2,tp,LOCATION_DECK,0,1,nil,c)
end
function c12340318.filter2(c,tp)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function c12340318.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c12340318.thfilter(c)
	return c:IsSetCard(0x205) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c12340318.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340318.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c12340318.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12340318.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end