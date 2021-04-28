--Evolza
function c203.initial_effect(c)
	--xyz summon
		Xyz.AddProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22325836,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetTarget(c203.target)
	e1:SetOperation(c203.activate)
	c:RegisterEffect(e1)
end
function c203.filter(c,e,tp)
	if not c:IsType(TYPE_SYNCHRO) then return false end
	return Duel.IsExistingMatchingCard(c203.matfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,tp,c)
end
function c203.matfilter1(c,tp,syncard)
	local loc
	if c:IsLocation(LOCATION_MZONE) then loc=LOCATION_GRAVE else loc=LOCATION_MZONE end
	return Duel.IsExistingMatchingCard(c203.matfilter2,tp,loc,0,1,c,syncard,c)
end
function c203.matfilter2(c,syncard,mc)
	return syncard:IsSynchroSummonable(nil,Group.FromCards(c,mc))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c203.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c203.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=-1 then return end
	local g=Duel.GetMatchingGroup(c203.filter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local g1=Duel.SelectMatchingCard(tp,c203.matfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil,tp,tc)
		local loc
		if g1:GetFirst():IsLocation(LOCATION_MZONE) then loc=LOCATION_GRAVE else loc=LOCATION_MZONE end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local g2=Duel.SelectMatchingCard(tp,c203.matfilter2,tp,loc,0,1,1,nil,tc,g1:GetFirst())
		g2:Merge(g1)
		Duel.SynchroSummon(tp,tc,nil,g2)
	end
end
