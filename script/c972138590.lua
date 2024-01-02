--Runic Underworld Chantress
c972138590.Is_Runic=true
if not Rune then Duel.LoadScript("proc_rune.lua") end
function c972138590.initial_effect(c)
	--rune procedure
	c:EnableReviveLimit()
	Rune.AddProcedure(c,Rune.MonFunction(nil),1,1,Rune.STFunction(nil),1,1)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(989512332,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c972138590.target)
	e1:SetOperation(c972138590.operation)
	c:RegisterEffect(e1)
	--Indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c972138590.matfilter(c)
	return c:IsSpellTrap()
end
function c972138590.filter(c)
	return (c:GetRank()==7 or c:GetRank()==8) and (c.Is_Runic or c:IsType(TYPE_RUNE)) and c:IsAbleToHand()
end
function c972138590.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c972138590.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c972138590.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c972138590.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
