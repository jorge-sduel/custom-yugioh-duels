--created by Swag, coded by Lyris
local cid,id=GetID()
function cid.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,cid.matfilter,2,2,cid.lcheck)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end)
	e1:SetTarget(cid.tetg)
	e1:SetOperation(cid.teop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id-7)
	e2:SetCost(cid.cost)
	e2:SetTarget(cid.target)
	e2:SetOperation(cid.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,id-5)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetCondition(cid.tgcon)
	e3:SetTarget(cid.tgtg)
	e3:SetOperation(cid.tgop)
	c:RegisterEffect(e3)
end
function cid.matfilter(c)
	return c:IsType(TYPE_EFFECT) and not c:IsType(TYPE_LINK)
end
function cid.lcheck(g,lc)
return g:IsExists(Card.IsType,1,nil,TYPE_PENDULUM) or c.IsEquilibrium
end
function cid.tefilter(c)
	return c:IsSetCard(0x9b5) and not c:IsForbidden()
end
function cid.tetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.tefilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_DECK)
end
function cid.teop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
	local g=Duel.SelectMatchingCard(tp,cid.tefilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
	
	end
end
function cid.cfilter(c,tp)
	return c:IsAbleToGraveAsCost() and (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c.IsEquilibrium))
		and Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_DECK,0,1,nil,c:GetOriginalCode())
end
function cid.filter(c,code)
	return c.IsType(TYPE_PENDULUM)
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.IsExistingMatchingCard(tp,cid.cfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cid.cfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,tp)
	e:SetLabel(g:GetFirst():GetOriginalCode())
	Duel.SendtoGrave(g,REASON_COST)
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cid.filter,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel())
	if #g>0 then
		Duel.ConfirmCards(1-tp,g)
	end
end
function cid.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return r&REASON_EFFECT~=0
end
function cid.thfilter(c)
	return c:IsFaceup() and c.IsEquilibrium and c:IsAbleToHand()
end
function cid.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.thfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA)
end
function cid.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cid.thfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
