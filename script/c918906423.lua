--Inscriber Homoji
c918906423.Is_Runic=true
if not RUNIC_IMPORTED then Duel.LoadScript("proc_runic.lua") end
function c918906423.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--Rune Summon
	c:EnableReviveLimit()
	aux.AddRunicProcedure2(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),c918906423.matfilter,1,1,LOCATION_EXTRA+LOCATION_HAND)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(918906423,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,918906423+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c918906423.thcost)
	e1:SetTarget(c918906423.thtg)
	e1:SetOperation(c918906423.thop)
	c:RegisterEffect(e1)
	--double
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e4:SetCondition(c918906423.damcon)
	e4:SetOperation(c918906423.damop)
	c:RegisterEffect(e4)
end
function c918906423.matfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c918906423.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() end
	Duel.Destroy(e:GetHandler(),REASON_COST)
end
function c918906423.thfilter(c)
	return c:IsSetCard(0xff0) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c918906423.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c918906423.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c918906423.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c918906423.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c918906423.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetBattleTarget()~=nil
end
function c918906423.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end
