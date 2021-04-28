----Sunavalon Yggdrasil
function c157.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	Link.AddProcedure(c,c157.matfilter,2)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c157.indtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c157.atkval)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(88264978,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c157.sptg)
	e4:SetOperation(c157.spop)
	c:RegisterEffect(e4)
end
function c157.matfilter(c)
	return c:IsType(TYPE_LINK) and c:IsRace(RACE_PLANT)
end
function c157.indtg(e,c)
	return c:GetMutualLinkedGroupCount()>0
end
function c157.atkfilter(c,ec)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:GetLinkedGroup():IsContains(ec)
end
function c157.atkval(e,c)
	local g=Duel.GetMatchingGroup(c157.atkfilter,0,LOCATION_MZONE,LOCATION_MZONE,nil,e:GetHandler())
	return g:GetSum(Card.GetLink)*1000
end
function c157.filter(c,e,tp)
	return c:IsRace(RACE_PLANT) and not c:IsCode(157) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c157.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c157.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c157.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c157.filter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
