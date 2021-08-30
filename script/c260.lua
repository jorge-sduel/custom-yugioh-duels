--guard trace
function c260.initial_effect(c)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(46037213,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c260.spcon)
	e4:SetTarget(c260.sptg)
	e4:SetOperation(c260.spop)
	c:RegisterEffect(e4)
end
c260.listed_names={21900719}
function c260.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c260.spfilter(c,e,tp,rc)
	return c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_SUMMON) and c:GetReasonCard()==rc and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c260.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return true end
	local g=e:GetHandler():GetMaterial():Filter(c260.spfilter,nil,e,tp,e:GetHandler())
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c260.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ct=g:GetCount()
	if ct>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
