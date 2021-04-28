--External Worlds Synchro Summon
--Scripted by Secuter
function c12340017.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c12340017.sptg)
	e1:SetOperation(c12340017.spop)
	c:RegisterEffect(e1)
end
function c12340017.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c12340017.synfilter(c)
	return c:IsSynchroSummonable()
end
function c12340017.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c12340017.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c12340017.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c12340017.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	local tc=g:GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local c=e:GetHandler()
   local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		local sc=Duel.SelectMatchingCard(tp,c12340017.synfilter,tp,LOCATION_EXTRA,0,1,1,nil):GetFirst()
		Duel.SynchroSummon(tp,sc)
	end
end