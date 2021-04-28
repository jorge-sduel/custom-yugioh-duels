--Fusion Master of Wickdness
function c12340119.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	Fusion.AddProcMixRep(c,true,true,aux.FilterBoolFunctionEx(Card.IsRace,RACE_ZOMBIE),2,99)
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--change base atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c12340119.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c12340119.spcon)
	e4:SetOperation(c12340119.valcheck)
	c:RegisterEffect(e4)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12340119,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,12340119)
	e4:SetTarget(c12340119.gytg)
	e4:SetOperation(c12340119.gyop)
	c:RegisterEffect(e4)
end
function c12340119.valcheck(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(c:GetMaterialCount()*800)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
end
function c12340119.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end

function c12340119.spfilter(c,e,tp,atk)
	return c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_FUSION) and c:GetAttack()<=atk
		and not c:IsCode(12340119) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12340119.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	local atk=e:GetHandler():GetPreviousAttackOnField()
	if chk==0 then return Duel.IsExistingMatchingCard(c12340119.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,atk) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c12340119.gyop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local atk=e:GetHandler():GetPreviousAttackOnField()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c12340119.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,atk)
	if g then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end