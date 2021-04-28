--Desert Hydra
function c12340402.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12340402,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,12340402)
	e1:SetTarget(c12340402.sptg)
	e1:SetOperation(c12340402.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12340402,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCondition(c12340402.descon)
	e4:SetTarget(c12340402.destg)
	e4:SetOperation(c12340402.desop)
	c:RegisterEffect(e4)
end

function c12340402.filter(c)
	return c:IsSetCard(0x206) and c:IsRace(RACE_REPTILE) and not c:IsCode(12340402) and c:IsAbleToHand()
end
function c12340402.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c12340402.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12340402.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c12340402.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c12340402.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsControler(tp) and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

function c12340402.hdfilter(c,e,tp)
	return c:IsSetCard(0x206) and c:IsRace(RACE_REPTILE) and c:GetLevel()>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
        and Duel.IsExistingTarget(c12340402.dkfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetLevel(),c:GetCode())
end
function c12340402.dkfilter(c,e,tp,lvl,code)
	return c:IsSetCard(0x206) and c:IsRace(RACE_REPTILE) and c:GetLevel()==lvl and c:GetCode()~=code
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12340402.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetReasonPlayer()~=tp
		and e:GetHandler():GetPreviousControler()==tp
end
function c12340402.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then return false end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return false end
		return Duel.IsExistingTarget(c12340402.hdfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_DECK)
end
function c12340402.desop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local tc1=Duel.SelectTarget(tp,c12340402.hdfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
    local lvl=tc1:GetLevel()
	local code=tc1:GetCode()
	local tc2=Duel.SelectTarget(tp,c12340402.dkfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,lvl,code):GetFirst()
	if tc1 and tc2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		Duel.SpecialSummonStep(tc1,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		Duel.SpecialSummonStep(tc2,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		Duel.SpecialSummonComplete()
	end
end