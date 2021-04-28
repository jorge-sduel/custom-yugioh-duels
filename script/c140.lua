--Drone XL
function c140.initial_effect(c)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c140.thtg)
	e3:SetOperation(c140.thop)
	c:RegisterEffect(e3)
		--token
		local e4=Effect.CreateEffect(c)
e4:SetDescription(aux.Stringid(140,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetCountLimit(1)
	e4:SetCondition(c140.tkcon)
	e4:SetTarget(c140.tktg)
	e4:SetOperation(c140.tkop)
	c:RegisterEffect(e4)
end
function c140.afilter(c)
	return c:IsSetCard(0x581) and c:GetType()==TYPE_SPELL+TYPE_QUICKPLAY and c:IsAbleToHand()
end
function c140.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c140.afilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c140.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c140.afilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c140.tkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsPreviousLocation(LOCATION_MZONE) and not c:IsSummonType(SUMMON_TYPE_SPECIAL)) and c:GetTurnID()==Duel.GetTurnCount()
end
function c140.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,511009746,0x51,0x4011,0,0,2,RACE_CYBERSE,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function c140.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,511009746,0x51,0x4011,0,0,2,RACE_CYBERSE,ATTRIBUTE_LIGHT) then return end
	local token=Duel.CreateToken(tp,511009746)
	Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
