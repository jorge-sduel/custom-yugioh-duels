--Dark King Servant
function c12340301.initial_effect(c)
	--ritual material from grave
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_RITUAL_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340301,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,12340301)
	e2:SetCondition(c12340301.cond)
	e2:SetCost(c12340301.cost)
	e2:SetTarget(c12340301.target)
	e2:SetOperation(c12340301.operation)
	c:RegisterEffect(e2)
end

function c12340301.cond(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_NORMAL)~=0
end
function c12340301.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c12340301.filter(c,e,tp)
	return c:IsSetCard(0x205) and c:IsAbleToHand()
end
function c12340301.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340301.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12340301.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12340301.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end