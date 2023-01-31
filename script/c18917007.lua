--Lyrica (WATER)
local ref=_G['c'..18917007]
ref.Is_Runic=true
if not RUNIC_IMPORTED then Duel.LoadScript("proc_runic.lua") end
function ref.initial_effect(c)
	--Rune Summon
	c:EnableReviveLimit()
	aux.AddRunicProcedure1(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),ref.matfilter,1,1)
	--Cannot Target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(aux.TRUE)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(18917007,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetTarget(ref.thtg)
	e2:SetOperation(ref.thop)
	c:RegisterEffect(e2)
end
function ref.matfilter(c)
	return c:IsType(TYPE_TRAP) or c:IsType(TYPE_SPELL)
end
function ref.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc:IsRace(RACE_SPELLCASTER) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsRace,tp,LOCATION_GRAVE,0,1,nil,RACE_SPELLCASTER) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,Card.IsRace,tp,LOCATION_GRAVE,0,1,1,nil,RACE_SPELLCASTER)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function ref.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
