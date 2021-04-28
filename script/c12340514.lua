--Fire Core Magic - Fire Ball
function c12340514.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_ATTACK,0x11e0)
	e1:SetCountLimit(1,12340514)
	e1:SetTarget(c12340514.destg)
	e1:SetOperation(c12340514.desop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c12340514.thcon)
	e2:SetTarget(c12340514.thtg)
	e2:SetOperation(c12340514.thop)
	c:RegisterEffect(e2)
end

function c12340514.desfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c12340514.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340514.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
        and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c12340514.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c12340514.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
		if g:GetCount()>0 then
            Duel.Destroy(g,REASON_EFFECT)
		end
	end
end

function c12340514.resfilter(c)
    return c:IsAttribute(ATTRIBUTE_FIRE) and bit.band(c:GetReason(),0x41)==0x41
end
function c12340514.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12340514.resfilter,1,nil)
end
function c12340514.thfilter(c)
	return c:IsAbleToDeck() and c:IsSetCard(0x1207) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end
function c12340514.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c12340514.thfilter(chkc) end
    if chk==0 then return c:GetFlagEffect(12340514)==0 and e:GetHandler():IsAbleToHand()
        and Duel.IsExistingTarget(c12340514.thfilter,tp,LOCATION_GRAVE,0,2,c) end
	local g=Duel.SelectTarget(tp,c12340514.thfilter,tp,LOCATION_GRAVE,0,2,2,c)
	c:RegisterFlagEffect(12340514,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c12340514.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end