--Spell
function c12340115.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,12340115+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c12340115.cost)
	e1:SetTarget(c12340115.target)
	e1:SetOperation(c12340115.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340115,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,12340115+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c12340115.thcost)
	e2:SetTarget(c12340115.thtg)
	e2:SetOperation(c12340115.thop)
	c:RegisterEffect(e2)
end

function c12340115.costfilter(c,tp)
	return c:IsRace(RACE_ZOMBIE) and c:IsAbleToGraveAsCost()
        and c:GetLevel()>0
		and Duel.IsPlayerCanDiscardDeck(tp,c:GetLevel())
end
function c12340115.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340115.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e:GetHandlerPlayer()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c12340115.costfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetFirst():GetLevel())
end
function c12340115.filter(c,e,tp)
	return c:IsRace(RACE_ZOMBIE) and c:GetAttack()==0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12340115.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c12340115.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function c12340115.activate(e,tp,eg,ep,ev,re,r,rp)
    local n=e:GetLabel()
	Duel.ConfirmDecktop(tp,n)
	local g=Duel.GetDecktopGroup(tp,n):Filter(c12340115.filter,nil,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if g:GetCount()>0 then
		if ft<=0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		elseif ft>=g:GetCount() then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,ft,ft,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_ATTACK)
			g:Sub(sg)
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
	Duel.ShuffleDeck(tp)
end

function c12340115.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c12340115.thfilter(c)
	return c:IsSetCard(0x202) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c12340115.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340115.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c12340115.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12340115.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end