--CCG: Charming Spirit Art - Shokan
function c27000309.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,27000309)
	e1:SetTarget(c27000309.target)
	e1:SetOperation(c27000309.activate)
	c:RegisterEffect(e1)
end
function c27000309.filter(c,e,tp)
	if not c:IsFaceup() or not c:IsSetCard(0xbf) then 
		return false 
	end
	local g1=Duel.GetMatchingGroup(c27000309.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp,c)
	local g2=Duel.GetMatchingGroup(c27000309.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp,c)
	g1:Merge(g2)
	return g1:GetClassCount(Card.GetCode)>0
end
function c27000309.filter2(c,e,tp,tc)
	return c:IsAttribute(tc:GetAttribute()) 
		and c:GetLevel()<=tc:GetLevel() 
		and not c:IsRace(tc:GetRace()) 
		and not c:IsType(TYPE_EFFECT) 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c27000309.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then 
		return chkc:IsLocation(LOCATION_MZONE) 
			and chkc:IsControler(tp) 
			and c27000309.filter(chkc,e,tp) 
	end
	if chk==0 then 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingTarget(c27000309.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c27000309.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function c27000309.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g1=Duel.GetMatchingGroup(c27000309.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,nil,e,tp,tc)
	local g2=Duel.GetMatchingGroup(c27000309.filter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp,tc)
	g1:Merge(g2)
	if ft>0 and g1:GetClassCount(Card.GetCode)>0 and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=g1:Select(tp,1,1,nil)
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	end
end
