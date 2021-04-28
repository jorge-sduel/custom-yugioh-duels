--Ancient Oracle S/T
function c12341419.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,12341419+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c12341419.target)
	e1:SetOperation(c12341419.operation)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12341419,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetCountLimit(1,12341419+EFFECT_COUNT_CODE_OATH+50)
	e2:SetTarget(c12341419.tg2)
	e2:SetOperation(c12341419.op2)
	c:RegisterEffect(e2)
end

function c12341419.filter(c,g,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and g:CheckWithSumEqual(Card.GetLevel,c:GetLevel(),1,99)
end
function c12341419.rfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c12341419.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local rg=Duel.GetMatchingGroup(c12341419.rfilter,tp,LOCATION_GRAVE,0,nil)
		return Duel.IsExistingMatchingCard(c12341419.filter,tp,LOCATION_REMOVED,0,1,nil,rg,e,tp)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
function c12341419.operation(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetMatchingGroup(c12341419.rfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(12341419,0))
	local g=Duel.SelectMatchingCard(tp,c12341419.filter,tp,LOCATION_REMOVED,0,1,1,nil,rg,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		Duel.ShuffleHand(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=rg:SelectWithSumEqual(tp,Card.GetLevel,tc:GetLevel(),1,99)
		if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)~=0 then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

function c12341419.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c12341419.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c12341419.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12341419.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,c12341419.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end
function c12341419.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
	end
end