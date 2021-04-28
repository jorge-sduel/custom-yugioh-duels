--Alien
function c86123177.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material	
Fusion.AddProcFunRep(c,c86123177.ffilter,2,false)
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(86123177,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetCondition(c86123177.condition)
	e1:SetTarget(c86123177.target)
	e1:SetOperation(c86123177.operation)
	c:RegisterEffect(e1)
end

function c86123177.ffilter(c)
    return c:GetCounter(0x100e)>0 or c:IsSetCard(0xc)
end

function c86123177.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_BATTLE) or (c:GetReasonPlayer()~=tp and c:IsReason(REASON_EFFECT)))
		and c:IsPreviousPosition(POS_FACEUP)
end
function c86123177.filter(c,e,tp)
	return c:IsCode(24104865) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c86123177.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c86123177.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_HAND+LOCATION_DECK)
end
function c86123177.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c86123177.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
    end
end