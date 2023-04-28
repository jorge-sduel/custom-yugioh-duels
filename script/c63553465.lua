--Stregone dell'Illusione
--Script by XGlitchy30
function c63553465.initial_effect(c)
	--link summon
	Link.AddProcedure(c,c63553465.matfilter,2,2)
	c:EnableReviveLimit()
	--set/special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(63553464,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,63553465)
	e1:SetCondition(c63553465.spcon)
	--e1:SetCost(c63553465.spcost)
	e1:SetTarget(c63553465.sptg)
	e1:SetOperation(c63553465.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(63553464,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,63553165)
	e2:SetCondition(c63553465.fdcon)
	e2:SetTarget(c63553465.fdtg)
	e2:SetOperation(c63553465.fdop)
	c:RegisterEffect(e2)
end
--filters
function c63553465.matfilter(c)
	return c.IsEquilibrium
end
function c63553465.spcostfilter(c,tp,e)
	return c:IsFaceup() and  c.IsEquilibrium
end
function c63553465.spfilter(c,lv,attr)
	--local clv=c:GetLevel()
	--local attr=c:GetAttribute()
	return c.IsEquilibrium and c:IsLevel(lv) and c:IsAttribute(attr)
end
function c63553465.thcfilter(c,lg)
	return lg:IsContains(c)
end
function c63553465.fdfilter(c,e,tp)
	return  c.IsEquilibrium and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) or not c:IsForbidden())
end
function c63553465.excfilter(c)
	return  c.IsEquilibrium
end
--set/special summon
function c63553465.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c63553465.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c63553465.spcostfilter,tp,LOCATION_MZONE,0,1,nil,tp,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c63553465.spcostfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,e):GetFirst()
	if g then
		Duel.Destroy(g,REASON_COST)
		--local op=Duel.GetOperatedGroup():GetFirst()
	end
end
function c63553465.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	--local lv=c63553465.check_same_level
	--local attr=c63553465.check_other_race
	if chk==0 then return Duel.IsExistingMatchingCard(c63553465.spcostfilter,tp,LOCATION_MZONE,0,1,nil,tp,e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c63553465.spop(e,tp,eg,ep,ev,re,r,rp)
	--local lv=c63553465.check_same_level
	--local attr=c63553465.check_other_race
	local g1=Duel.SelectMatchingCard(tp,c63553465.spcostfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,e):GetFirst()
	local lv=g1:GetLevel()
	local attr=g1:GetAttribute()
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectMatchingCard(tp,c63553465.spfilter,tp,LOCATION_DECK,0,1,1,nil,lv,attr,e,tp)
	if g2:GetCount()>0 then
		Duel.Destroy(g1,REASON_COST)
		Duel.SpecialSummon(g2:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
	end
end
--search
function c63553465.fdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	return not eg:IsContains(c) and eg:FilterCount(c63553465.thcfilter,nil,lg)==2
end
function c63553465.fdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 or Duel.CheckPendulumZones(tp)) and Duel.IsExistingMatchingCard(c63553465.fdfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c63553465.fdop(e,tp,eg,ep,ev,re,r,rp)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.CheckPendulumZones(tp)
	if ft1<=0 and not ft2<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22499034,3))
	local g=Duel.SelectMatchingCard(tp,c63553465.fdfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		local b1=tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		local b2=tc:IsForbidden()
		if (b1 and ft1>0) and (not b2 or ft2<=0) and Duel.SelectYesNo(tp,aux.Stringid(63553465,2)) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			--tc:SetCardData(CARDDATA_TYPE,TYPE_TRAP+TYPE_CONTINUOUS)
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			if not tc:IsLocation(LOCATION_PZONE) then
				local edcheck=0
				if tc:IsLocation(LOCATION_EXTRA) then edcheck=TYPE_PENDULUM end
				--Card.SetCardData(tc,CARDDATA_TYPE,TYPE_MONSTER+TYPE_EFFECT+edcheck)
			else
				tc:RegisterFlagEffect(726,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CANNOT_DISABLE,1)
			end
		end
	end
end
