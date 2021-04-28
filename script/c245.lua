--Ss xyz fire
function c245.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,4,2,c245.ovfilter,aux.Stringid(93854893,0),2)
	c:EnableReviveLimit()
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(c245.atkval)
	c:RegisterEffect(e1)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(63288573,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,245)
	e3:SetCost(c245.cost)
	e3:SetTarget(c245.thtg)
	e3:SetOperation(c245.thop)
	c:RegisterEffect(e3,false,REGISTER_FLAG_DETACH_XMAT)
end
function c245.ovfilter(c,tp,xyzc)
	return c:IsFaceup() and c:IsType(TYPE_LINK,xyzc,SUMMON_TYPE_XYZ,tp) and c:IsAttribute(ATTRIBUTE_FIRE,xyzc,SUMMON_TYPE_XYZ,tp)
end
function c245.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c245.atkval(e)
	return Duel.GetMatchingGroupCount(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,TYPE_SPELL)*200
end
function c245.thfilter(c,tp)
	return c:IsSetCard(0x115) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c245.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c63288573.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c245.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c245.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
end
function c245.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
