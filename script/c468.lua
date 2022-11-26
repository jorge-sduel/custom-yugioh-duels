--"Link-Up-Magic"
function c468.initial_effect(c)
	--"Activate"
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetTarget(c468.target)
	e0:SetOperation(c468.activate)
	c:RegisterEffect(e0)
end
function c468.filter1(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
		and Duel.IsExistingMatchingCard(c468.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
		and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c468.filter2(c,e,tp,mc)
	return c:IsType(TYPE_LINK) and c:IsLink(mc:GetLink()+1) and mc:IsCanBeLinkMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false)
end
function c468.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c90800.filter1(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c468.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c468.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c468.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c90800.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
	local sc=g:GetFirst()
	if sc then
		sc:SetMaterial(Group.FromCards(tc))
		Duel.SendtoGrave(tc,REASON_EFFECT+REASON_MATERIAL+REASON_LINK)
		Duel.SpecialSummon(sc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end