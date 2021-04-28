--SS fus fire
function c251.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcFun2(c,c251.ffilter,aux.FilterBoolFunction(Card.IsSetCard,0x1115),true)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(c251.atkval)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(129,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c251.rectg)
	e2:SetOperation(c251.recop)
	c:RegisterEffect(e2)
	--Special summon
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(4796100,0))
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetTarget(c251.sptg)
	e7:SetOperation(c251.spop)
	c:RegisterEffect(e7)
end
function c251.ffilter(c)
	return c:IsCode(63288573)
end
function c251.filter(c)
	return c:IsType(TYPE_SPELL)
end
function c251.atkval(e)
	return Duel.GetMatchingGroupCount(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,TYPE_LINK)*400
end
function c251.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function c251.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetMatchingGroupCount(c251.filter,tp,LOCATION_GRAVE,0,nil)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ct*100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,ct*100)
end
function c251.recop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c251.filter,tp,LOCATION_GRAVE,0,nil)
	Duel.Damage(1-tp,ct*100,REASON_EFFECT)
end
function c251.spfilter(c,e,tp)
	return c:IsSetCard(0x1115) and not c: IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c251.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c251.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c251.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c251.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c251.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end