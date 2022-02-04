--Star-vader, Magnet Hollow
function c884.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.XyzFilterFunction(c,6),2)
	c:EnableReviveLimit()
	--Add to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(884,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c884.cost)
	e1:SetTarget(c884.thtg1)
	e1:SetOperation(c884.thop1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(884,1))
	e2:SetTarget(c884.thtg2)
	e2:SetOperation(c884.thop2)
	c:RegisterEffect(e2)
end
function c884.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST)
	and e:GetHandler():GetFlagEffect(884)==0 end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	e:GetHandler():RegisterFlagEffect(884,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c884.thfilter(c)
	return c:IsSetCard(0x5AA)
end
function c884.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:GetControler()==tp and chkc:GetLocation()==LOCATION_DECK and c884.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c884.thfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c884.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c884.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c884.thfilter2(c)
	return c:IsSetCard(0x5AA) and c:IsFaceup()
end
function c884.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:GetControler()==tp and 
	(chkc:GetLocation()==LOCATION_ONFIELD or chkc:GetLocation()==LOCATION_GRAVE) and c884.thfilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c884.thfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) end
end
function c884.thop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c884.thfilter2,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end