--Asura S/T
function c12340913.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCost(c12340913.cost)
	e1:SetOperation(c12340913.activate)
	c:RegisterEffect(e1)
end

function c12340913.spfilter(c,e,tp,attr)
	return c:IsLevelAbove(7) and c:IsSummonableCard() and not c:IsAttribute(attr) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12340913.cfilter(c,e,tp)
	return c:IsFaceup() and c:IsLevelAbove(7) and c:IsSummonType(SUMMON_TYPE_NORMAL) and c:IsAbleToHandAsCost()
		and Duel.IsExistingMatchingCard(c12340913.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,attr)
end
function c12340913.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340913.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c12340913.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local attr=g:GetFirst():GetAttribute()
	Duel.SendtoHand(g,nil,REASON_COST)
	e:SetLabel(attr)
end
function c12340913.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_DECK)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c12340913.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,e:GetLabel())
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end