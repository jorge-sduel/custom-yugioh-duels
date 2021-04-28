--chronologyc sanctuary
function c269.initial_effect(c)
	c:EnableCounterPermit(0x5f)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_PHASE_START+PHASE_END)
	e2:SetCondition(c269.ccon)
	e2:SetOperation(c269.ctop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(6061630,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTarget(c269.sptg)
	e3:SetOperation(c269.spop)
	c:RegisterEffect(e3)
end
function c269.ccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c269.ctop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,100100090) then return end
	e:GetHandler():AddCounter(0x5f,1)
end
function c269.filter(c,cc,e,tp)
	return c:IsSetCard(0x5f) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
		and c:GetLevel()>0 and cc:IsCanRemoveCounter(tp,0x5f,c:GetLevel(),REASON_COST)
end
function c269.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c269.filter,tp,LOCATION_HAND,0,1,nil,e:GetHandler(),e,tp) end
	local g=Duel.GetMatchingGroup(c269.filter,tp,LOCATION_HAND,0,nil,e:GetHandler(),e,tp)
	local lvt={}
	local tc=g:GetFirst()
	while tc do
		local tlv=tc:GetLevel()
		lvt[tlv]=tlv
		tc=g:GetNext()
	end
	local pc=1
	for i=1,12 do
		if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end
	end
	lvt[pc]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(6061630,1))
	local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
	e:GetHandler():RemoveCounter(tp,0x5f,lv,REASON_COST)
	e:SetLabel(lv)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c269.sfilter(c,lv,e,tp)
	return c:IsSetCard(0x5f) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
		and c:IsLevel(lv)
end
function c269.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c269.sfilter),tp,LOCATION_HAND,0,1,1,nil,lv,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end
