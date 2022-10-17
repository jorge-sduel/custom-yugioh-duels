--Protective Prince
function c996821023.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,11,2,c996821023.ovfilter,aux.Stringid(85115440,0),2)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1855932,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c996821023.matcon)
	e1:SetTarget(c996821023.mattg)
	e1:SetOperation(c996821023.matop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(96381979,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c996821023.setcost)
	e2:SetTarget(c996821023.settg)
	e2:SetOperation(c996821023.setop)
	c:RegisterEffect(e2)
end
function c996821023.ovfilter(c)
	return c:IsFaceup() and c.Is_Runic and c:IsRankAbove(7)
end
function c996821023.matcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c996821023.mattg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c996821023.matop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local c=e:GetHandler()
	if g:GetCount()>0 and c:IsRelateToEffect(e) then
		local sg=g:RandomSelect(1-tp,1)
		Duel.Overlay(c,sg)
	end
end
function c996821023.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c996821023.filter(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsSSetable()
end
function c996821023.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c996821023.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c996821023.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c996821023.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end
