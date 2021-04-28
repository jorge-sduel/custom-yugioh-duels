--Ancient Oracle S/T
function c12341417.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,12341417+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c12341417.descost)
	e1:SetTarget(c12341417.destg)
	e1:SetOperation(c12341417.desop)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12341417,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,12341417+EFFECT_COUNT_CODE_OATH+50)
	e2:SetTarget(c12341417.tg2)
	e2:SetOperation(c12341417.op2)
	c:RegisterEffect(e2)
end
function c12341417.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x53,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x53,2,REASON_COST)
end
function c12341417.filter(c)
	return c:IsSetCard(0x211) and c:IsAbleToHand()
end
function c12341417.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingTarget(c12341417.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectTarget(tp,c12341417.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g2,1,0,0)
end
function c12341417.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local tc1=g:Filter(Card.IsLocation,nil,LOCATION_ONFIELD)
	local tc2=g:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if tc1:GetCount()>0 then
		if Duel.SendtoGrave(tc1,REASON_EFFECT)~=0 and tc1:GetFirst():IsLocation(LOCATION_GRAVE)
			and tc2:GetCount()>0 and tc2:GetFirst():IsLocation(LOCATION_GRAVE) then
				Duel.SendtoHand(tc2,nil,REASON_EFFECT)
		end
	end
end

function c12341417.thfilter(c)
	return c:IsSetCard(0x211) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(12341417) and c:IsAbleToDeck()
end
function c12341417.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c12341417.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12341417.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c12341417.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,HINTMSG_TODECK,g,1,0,0)
end
function c12341417.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)
	end
end