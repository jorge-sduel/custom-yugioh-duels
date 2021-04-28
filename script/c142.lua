--Recicler drone
function c142.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(53274132,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c142.target)
	e1:SetOperation(c142.operation)
	c:RegisterEffect(e1)
end
function c142.filter(c,g,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x581) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and g:CheckWithSumGreater(Card.GetLink,c:GetLevel(),1,1)
end
function c142.rfilter(c)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0x581) and c:IsAbleToRemove()
end
function c142.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local rg=Duel.GetMatchingGroup(c142.rfilter,tp,LOCATION_GRAVE,0,nil)
		return Duel.IsExistingMatchingCard(c142.filter,tp,LOCATION_HAND,0,1,nil,rg,e,tp)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
function c142.operation(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetMatchingGroup(c142.rfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(12341419,0))
	local g=Duel.SelectMatchingCard(tp,c142.filter,tp,LOCATION_HAND,0,1,1,nil,rg,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		Duel.ShuffleHand(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=rg:SelectWithSumGreater(tp,Card.GetLink,tc:GetLevel(),1,1)
		if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)~=0 then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end