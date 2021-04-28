--Spell
function c12340112.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,12340112+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c12340112.cost)
	e1:SetTarget(c12340112.target)
	e1:SetOperation(c12340112.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340112,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,12340112+EFFECT_COUNT_CODE_OATH)
	--e2:SetCondition(aux.exccon)
	e2:SetCost(c12340112.thcost)
	e2:SetTarget(c12340112.thtg)
	e2:SetOperation(c12340112.thop)
	c:RegisterEffect(e2)
end

function c12340112.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c12340112.filter(c,e,tp)
	return c:IsDefenseBelow(0) and c:IsRace(RACE_ZOMBIE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12340112.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c12340112.filter,tp,LOCATION_GRAVE,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end
function c12340112.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local g=Duel.GetMatchingGroup(c12340112.filter,tp,LOCATION_GRAVE,0,nil,e,tp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local sg=g:Select(tp,2,2,nil)
    local tc=sg:GetFirst()
	while tc do
        Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
        tc:RegisterFlagEffect(12340112,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,fid)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
        e1:SetRange(LOCATION_MZONE)
        e1:SetCode(EVENT_PHASE+PHASE_END)
        e1:SetOperation(c12340112.desop)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        e1:SetCountLimit(1)
        tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
end
function c12340112.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end

function c12340112.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c12340112.thfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsDefenseBelow(0) and c:IsAbleToHand()
end
function c12340112.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340112.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12340112.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12340112.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end