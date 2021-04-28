--new order 11
function c304.initial_effect(c)
	c:EnableReviveLimit()
	--Xyz summon procedure
	Xyz.AddProcedure(c,nil,11,2)
	--Negate the effect of a card/effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(304,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c304.discon)
	e1:SetCost(c304.damcost)
	e1:SetTarget(c304.distg)
	e1:SetOperation(c304.disop)
	c:RegisterEffect(e1,false,REGISTER_FLAG_DETACH_XMAT)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c304.efilter)
	c:RegisterEffect(e2)
end
function c304.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c304.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c304.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainDisablable(ev) and not re:GetHandler():IsCode(304) 
end
function c304.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c304.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and c:IsRelateToEffect(e) and rc:IsRelateToEffect(re) then
		Duel.SendtoGrave(rc,REASON_EFFECT)
		Duel.Overlay(c,Group.FromCards(rc))
	end
end
