--Morhai Link
function c12340715.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsLinkSetCard,0x209),2,3)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c12340715.atkval)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetCondition(c12340715.incon)
	e2:SetValue(aux.tgoval)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(c12340715.inval)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12340715,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,12340715)
	e4:SetCondition(c12340715.thcon)
	e4:SetTarget(c12340715.thtg)
	e4:SetOperation(c12340715.thop)
	c:RegisterEffect(e4)
end
function c12340715.atkval(e,c)
	return c:GetLinkedGroupCount()*500
end
function c12340715.incon(e)
	return e:GetHandler():GetLinkedGroupCount()>0
end
function c12340715.inval(e,re,r,rp)
	return rp~=e:GetHandlerPlayer()
end

function c12340715.descon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():GetLinkedGroup():IsExists(Card.IsSetCard,1,nil,0x209)
		and e:GetHandler():GetLinkedGroup():IsExists(Card.IsControler,1,nil,1-tp)
end

function c12340715.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetReasonPlayer()~=tp and c:IsReason(REASON_EFFECT) and c:IsPreviousPosition(POS_FACEUP)
		and c:GetPreviousControler()==c:GetOwner() and c:IsSummonType(SUMMON_TYPE_LINK)
end
function c12340715.thfilter(c)
	return c:IsSetCard(0x209) and c:IsAbleToHand()
end
function c12340715.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c12340715.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12340715.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c12340715.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c12340715.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end