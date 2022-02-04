--Silver Thorn Dragon Tamer, Luquier
function c906.initial_effect(c)
	--Atk up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(906,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c906.atkcon)
	e1:SetOperation(c906.atkop)
	c:RegisterEffect(e1)
	--Limit Break
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(906,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c906.spcon)
	e2:SetCost(c906.spcost)
	e2:SetTarget(c906.sptg)
	e2:SetOperation(c906.spop)
	c:RegisterEffect(e2)
end
function c906.atkfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c906.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c906.atkfilter,1,nil,tp)
end
function c906.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(300)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
function c906.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(e:GetHandlerPlayer())<4001
end
function c906.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c906.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c906.spfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_OVERLAY)
end
function c906.spfilter(c)
	return c:IsType(TYPE_XYZ) and c:GetOverlayCount()>0
	and c:GetOverlayGroup():IsExists(c906.spfilter2,1,nil)
end
function c906.spfilter2(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c906.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.SelectMatchingCard(tp,c906.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	local g1=tc:GetOverlayGroup()
	local sg=g1:FilterSelect(tp,c906.spfilter2,1,1,nil)
	if sg then
		Duel.SpecialSummon(sg,0,tp,tp,true,true,POS_FACEUP)
	end
end