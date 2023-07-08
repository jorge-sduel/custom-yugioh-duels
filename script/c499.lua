--Ｅvil・ＨＥＲＯ
local s,id=GetID()
function s.initial_effect(c)
	--Search 1 "Dark Fusion"
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
e3:SetTarget(s.thtg1)
	e3:SetOperation(s.thop1)
	c:RegisterEffect(e3)
local e4=e1:Clone()
	e4:SetDescription(aux.Stringid(id,3))
	e4:SetCode(EVENT_SUMMON_SUCCESS)
e4:SetTarget(s.thtg1)
	e4:SetOperation(s.thop1)
	c:RegisterEffect(e4)
	--direct attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e5)
end
s.listed_series={0x3008}
s.listed_names={CARD_DARK_FUSION}
function s.thfilter(c)
	return c:IsAbleToHand() and (c:IsCode(CARD_DARK_FUSION) or c:ListsCode(CARD_DARK_FUSION))
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.thfilter1(c)
	return c:IsMonster() and c:IsSetCard(0x6008) and c:IsAbleToGraveAsCost()
end
function s.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end