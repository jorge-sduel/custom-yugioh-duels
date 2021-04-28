--External Worlds Lord
--Scripted by Secuter
function c12340011.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12340011,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,12340011)
	e1:SetCondition(c12340011.cond)
	c:RegisterEffect(e1)
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340011,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCost(c12340011.cost)
	e2:SetTarget(c12340011.target)
	e2:SetOperation(c12340011.operation)
	c:RegisterEffect(e2)
end

function c12340011.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x201)
end
function c12340011.filter2(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND)
end
function c12340011.cond(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and	Duel.IsExistingMatchingCard(c12340011.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
		and Duel.GetMatchingGroupCount(c12340011.filter2,c:GetControler(),LOCATION_MZONE,0,nil)==0
end

function c12340011.costfilter(c)
	return c:IsSetCard(0x201) and c:IsAbleToRemoveAsCost() and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c12340011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340011.costfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c12340011.costfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c12340011.efilter(c)
	return c:IsFaceup()
end
function c12340011.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c12340011.efilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c12340011.efilter,tp,0,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c12340011.efilter,tp,0,LOCATION_MZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c12340011.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end