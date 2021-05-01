--Reverse-Xyz
function c12340323.initial_effect(c)
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,c12340323.xyzfilter,nil,2,nil,nil,nil,nil,false,c12340323.xyzcheck)
	--attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c12340323.atkval)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12340323,0))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,12340323)
	e3:SetCost(c12340323.cost)
	e3:SetTarget(c12340323.target)
	e3:SetOperation(c12340323.operation)
	c:RegisterEffect(e3,false,REGISTER_FLAG_DETACH_XMAT)
end
function c12340323.xyzfilter(c,xyz,sumtype,tp)
	return c:IsType(TYPE_MONSTER,xyz,sumtype,tp) and (c:IsLevel(3) and c:IsAttribute(ATTRIBUTE_DARK) or c:IsLevel(6) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_RITUAL))
end
function c12341310.xyzcheck(g,tp,xyz)
	local mg=g:Filter(function(c) return not c:IsHasEffect(511001175) end,nil)
	return mg:GetClassCount(Card.GetLevel)~=1
end
function c12340323.rifilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_RITUAL)
end

function c12340323.atkfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK)
end
function c12340323.atkval(e,c)
	return Duel.GetMatchingGroupCount(c12340323.atkfilter,c:GetControler(),LOCATION_REMOVED,0,nil)*200
end

function c12340323.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local tc=e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c12340323.filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c12340323.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c12340323.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c12340323.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c12340323.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c12340323.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
