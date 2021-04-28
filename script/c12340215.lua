--ToDeck
function c12340215.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	--e1:SetCondition(c12340215.cond)
	e1:SetCost(c12340215.cost)
	e1:SetTarget(c12340215.target)
	e1:SetOperation(c12340215.activate)
	c:RegisterEffect(e1)
end

function c12340215.cond(c)
	return Duel.IsExistingMatchingCard(c12340215.filter,tp,LOCATION_MZONE,0,1,nil)
        and Duel.IsExistingMatchingCard(c12340215.tdfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c12340215.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x204) and c:IsAbleToDeckOrExtraAsCost()
end
function c12340215.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340215.filter,tp,LOCATION_MZONE,0,1,nil)
        and Duel.IsExistingTarget(c12340215.tdfilter,tp,0,LOCATION_MZONE,1,e:GetHandler()) end
	local tc=Duel.SelectMatchingCard(tp,c12340215.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoDeck(tc,nil,0,REASON_COST)
end
function c12340215.tdfilter(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end
function c12340215.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	--if chkc then return chkc:IsOnField() and c12340215.tdfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c12340215.tdfilter,tp,0,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c12340215.tdfilter,tp,0,LOCATION_MZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c12340215.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end