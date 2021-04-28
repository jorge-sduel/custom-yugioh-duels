--Anuak Continuous S/T
function c12340617.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12340617,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,12340617+EFFECT_COUNT_CODE_OATH)
	e3:SetCondition(c12340617.spcon)
	e3:SetTarget(c12340617.sptg)
	e3:SetOperation(c12340617.spop)
	c:RegisterEffect(e3)
	--normal
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340617,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetCountLimit(1,12340617)
	e2:SetCondition(c12340617.dcon)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT))
	c:RegisterEffect(e2)
	local e4=e2:Clone()
	e4:SetDescription(aux.Stringid(12340617,2))
	e4:SetCondition(c12340617.lcon)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK))
	c:RegisterEffect(e4)
end

function c12340617.dcon(e,tp,eg,ep,ev,re,r,rp,chk)
    local test=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 and not Duel.IsExistingMatchingCard(c12340617.dfilter,tp,LOCATION_MZONE,0,1,nil)
    print("Light :")
    print(test)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
		and not Duel.IsExistingMatchingCard(c12340617.dfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c12340617.dfilter(c)
	return c:IsFacedown() or not c:IsAttribute(ATTRIBUTE_DARK)
end
function c12340617.lcon(e,tp,eg,ep,ev,re,r,rp,chk)
    local test=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 and not Duel.IsExistingMatchingCard(c12340617.lfilter,tp,LOCATION_MZONE,0,1,nil)
    print("Dark :")
    print(test)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
		and not Duel.IsExistingMatchingCard(c12340617.lfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c12340617.lfilter(c)
	return c:IsFacedown() or not c:IsAttribute(ATTRIBUTE_LIGHT)
end

function c12340617.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_DESTROY)
end
function c12340617.spfilter(c,e,tp)
	return c:IsSetCard(0x208) and c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevelBelow(4)
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c12340617.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)   
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c12340617.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c12340617.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c12340617.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
    end
end