--Anuak Link
function c12340614.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	Link.AddProcedure(c,nil,2,2)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12340614,2))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,12340614)
	e1:SetCondition(c12340614.thcon)
	e1:SetTarget(c12340614.thtg)
	e1:SetOperation(c12340614.thop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340614,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,12340614+EFFECT_COUNT_CODE_OATH)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c12340614.conlight)
	e2:SetTarget(c12340614.spdark)
	e2:SetOperation(c12340614.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(12340614,1))
	e3:SetCondition(c12340614.condark)
	e3:SetTarget(c12340614.splight)
	c:RegisterEffect(e3)
end
function c12340614.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c12340614.thfilter(c,e,tp,code)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand() 
end
function c12340614.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c12340614.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12340614.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c12340612.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c12340614.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

function c12340614.filterlight(c,tp,lg)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and lg:IsContains(c)
end
function c12340614.conlight(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return eg:IsExists(c12340614.filterlight,1,nil,tp,lg)
end
function c12340614.filterdark(c,tp,lg)
	return c:IsAttribute(ATTRIBUTE_DARK) and lg:IsContains(c)
end
function c12340614.condark(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return eg:IsExists(c12340614.filterdark,1,nil,tp,lg)
end

function c12340614.spfilterdark(c,e,tp,zone)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c12340614.spdark(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local zone=e:GetHandler():GetLinkedZone(tp)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_HAND) and c12340614.spfilterdark(chkc,e,tp,zone) end
	if chk==0 then return e:GetHandler():GetLinkedZone(tp)>0
		and Duel.IsExistingMatchingCard(c12340614.spfilterdark,tp,LOCATION_HAND,0,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c12340614.spfilterdark,tp,LOCATION_HAND,0,1,1,nil,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c12340614.spfilterlight(c,e,tp,zone)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c12340614.splight(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local zone=e:GetHandler():GetLinkedZone(tp)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_HAND) and c12340614.spfilterlight(chkc,e,tp,zone) end
	if chk==0 then return e:GetHandler():GetLinkedZone(tp)>0
		and Duel.IsExistingMatchingCard(c12340614.spfilterlight,tp,LOCATION_HAND,0,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c12340614.spfilterlight,tp,LOCATION_HAND,0,1,1,nil,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end

function c12340614.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,e:GetHandler():GetLinkedZone(tp))
	end
end