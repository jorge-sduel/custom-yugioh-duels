--External Worlds Fortress
--Scripted by Secuter
function c12340015.initial_effect(c)
	c:SetUniqueOnField(1,0,12340015)
	c:EnableCounterPermit(0x50)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetOperation(c12340015.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--add
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12340015,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c12340015.cost1)
	e4:SetTarget(c12340015.tg1)
	e4:SetOperation(c12340015.op1)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(12340015,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1)
	e5:SetCost(c12340015.cost2)
	e5:SetTarget(c12340015.tg2)
	e5:SetOperation(c12340015.op2)
	c:RegisterEffect(e5)
end
function c12340015.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x201)
end
function c12340015.ctop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c12340015.ctfilter,1,nil) then
		e:GetHandler():AddCounter(0x50,1)
	end
end

function c12340015.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x50,2,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    e:GetHandler():RemoveCounter(tp,0x50,2,REASON_COST)
end
function c12340015.filter1(c)
	return c:IsSetCard(0x201) and c:IsAbleToHand() and c:IsFaceup()
end
function c12340015.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340015.filter1,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function c12340015.op1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12340015.filter1,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c12340015.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x50,6,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    e:GetHandler():RemoveCounter(tp,0x50,6,REASON_COST)
end
function c12340015.filter2(c,e,tp)
	return c:IsSetCard(0x201) and c:IsType(TYPE_MONSTER) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12340015.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_GRAVE end
	if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
    
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE+LOCATION_EXTRA) and c12340015.filter2(chkc,e,tp) end
	if chk==0 then return loc~=0 and Duel.IsExistingTarget(c12340015.filter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c12340015.filter2,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c12340015.op2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end