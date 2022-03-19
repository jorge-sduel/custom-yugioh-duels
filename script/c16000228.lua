--Allure Rose Maiden
function c16000228.initial_effect(c)
c16000228.IsEvolute=true
if not EVOLUTE_IMPORTED then Duel.LoadScript("proc_evolute.lua") end
	c:EnableCounterPermit(0x88)
	c:EnableReviveLimit()
	Evolute.AddProcedure(c,nil,2,99,c16000228.rcheck)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16000228,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,16000228)
	e1:SetCost(c16000228.drcost)
	e1:SetTarget(c16000228.thtg)
	e1:SetOperation(c16000228.thop)
	c:RegisterEffect(e1)
end
function c16000228.rcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WATER)
		and g:IsExists(Card.IsRace,1,nil,RACE_PLANT)
end
function c16000228.filter2(c,ec,tp)
	return c:IsRace(RACE_PLANT) or c:IsAttribute(ATTRIBUTE_WATER)
end

function c16000228.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	  if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x88,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x88,3,REASON_COST)
end
function c16000228.discfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_PLANT) and c:IsAbleToGraveAsCost() and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c16000228.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	   if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x8,3,REASON_COST) and Duel.IsExistingMatchingCard(c16000228.discfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,c) end
	e:GetHandler():RemoveCounter(tp,0x88,3,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c16000228.discfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c16000228.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
