--Oak Gardna of Fiber VINE
function c16000130.initial_effect(c)
c16000130.IsEvolute=true
if not EVOLUTE_IMPORTED then Duel.LoadScript("proc_evolute.lua") end
	c:EnableCounterPermit(0x88)
	c:EnableReviveLimit()
	Evolute.AddProcedure(c,nil,2,2,c16000130.rcheck)
   local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	  --spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_LEAVE_FIELD_P)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetOperation(c16000130.regop)
	c:RegisterEffect(e0)
	--Special Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(16000130,0))
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCountLimit(1,16000130)
	e4:SetLabelObject(e0)
	e4:SetCondition(c16000130.sumcon)
	e4:SetTarget(c16000130.sumtg)
	e4:SetOperation(c16000130.sumop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetDescription(aux.Stringid(16000130,1))
	e5:SetCondition(c16000130.sumcon)
	e5:SetTarget(c16000130.sptg)
	e5:SetOperation(c16000130.spop)
	c:RegisterEffect(e5)
end
function c16000130.rcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_EARTH)
		and (g:IsExists(Card.IsRace,1,nil,RACE_PLANT) or g:IsExists(Card.IsRace,1,nil,RACE_INSECT))
end
function c16000130.filter2(c,ec,tp)
	return c:IsRace(RACE_PLANT) or c:IsAttribute(ATTRIBUTE_EARTH)
end
function c16000130.regop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetCounter(0x88)>=1 then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c16000130.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	 return e:GetHandler():IsPreviousPosition(POS_FACEUP)  and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and  e:GetLabelObject():GetLabel()==1
end
function c16000130.filter(c,e,tp)
	return  c:IsType(TYPE_RITUAL) and  c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) 
end
function c16000130.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c16000130.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c16000130.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c16000130.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc  then
	   Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	  tc:CompleteProcedure()
	end
end
function c16000130.spfilter(c,e,tp)
	return c.IsEvolute and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL+SUMMON_TYPE_EVOLUTE,tp,false,true) and not c:IsCode(16000130)
end
function c16000130.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return Duel.GetLocationCountFromEx(tp)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c16000130.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
end
function c16000130.spop(e,tp,eg,ep,ev,re,r,rp)
	 if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c16000130.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc  then
	   Duel.SpecialSummon(tc,SUMMON_TYPE_SPECIAL+388,tp,tp,false,true,POS_FACEUP)
	tc:CompleteProcedure()
	end
end
