--BetweenWorlds Link
function c12340022.initial_effect(c)
	--link summon
	Link.AddProcedure(c,nil,2,2)
	c:EnableReviveLimit()
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12340022,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,12340022)
	e1:SetCondition(c12340022.con)
	e1:SetTarget(c12340022.tg)
	e1:SetOperation(c12340022.op)
	c:RegisterEffect(e1)
end
function c12340022.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c12340022.cfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12340022.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c12340022.cfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c12340022.op(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if zone==0 then return end
	--local g=Duel.GetMatchingGroup(c12340022.cfilter,tp,LOCATION_REMOVED,0,nil,e,tp,zone)
	local g=Duel.SelectMatchingCard(tp,c12340022.cfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		--local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end