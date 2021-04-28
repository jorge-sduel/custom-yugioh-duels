--Instant Tune
function c12.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,12)
	e1:SetTarget(c12.target)
	e1:SetOperation(c12.activate)
	c:RegisterEffect(e1)
end
function c12.filter(c,tp,mg,ec)
	return c:IsType(TYPE_SYNCHRO) and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0 and c:IsSynchroSummonable(ec,mg)
end
c12.matfilter=aux.FilterFaceupFunction(Card.IsCanBeSynchroMaterial)
function c12.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local mg=Duel.GetMatchingGroup(c12.matfilter,tp,LOCATION_MZONE,0,nil)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_MONSTER+TYPE_TUNER)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SYNCHRO_LEVEL)
		e2:SetValue(1)
		c:RegisterEffect(e2)
		local res=Duel.IsExistingMatchingCard(c12.filter,tp,LOCATION_EXTRA,0,1,nil,tp,mg,e:GetHandler())
		e1:Reset()
		e2:Reset()
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c12.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetValue(TYPE_MONSTER+TYPE_TUNER)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SYNCHRO_LEVEL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local mg=Duel.GetMatchingGroup(c12.matfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c12.filter,tp,LOCATION_EXTRA,0,1,1,nil,tp,mg,e:GetHandler()):GetFirst()
	if sc then
		c:CancelToGrave()
		Duel.SynchroSummon(tp,sc,c,mg)
	end
end
