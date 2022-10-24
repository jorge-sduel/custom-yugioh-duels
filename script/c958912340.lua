--Haunted Bones' Call
function c958912340.initial_effect(c)
	--Rune Summon
	c:EnableReviveLimit()
	aux.AddRuneProcedure(c,nil,2,2,aux.FilterBoolFunction(Card.IsCode,97077563),1,1)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(958912340,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c958912340.settg)
	e3:SetOperation(c958912340.setop)
	c:RegisterEffect(e3)
end
function c958912340.filter(c)
	return c:IsCode(97077563) and c:IsSSetable(true)
end
function c958912340.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>-1
		and Duel.IsExistingMatchingCard(c958912340.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c958912340.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c958912340.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end
