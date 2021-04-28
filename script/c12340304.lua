--Dark King Servant
function c12340304.initial_effect(c)
	--ritual material from grave
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_RITUAL_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340304,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,12340304)
	e2:SetCondition(c12340304.spcon)
	e2:SetOperation(c12340304.spop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12340304,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,12340304+EFFECT_COUNT_CODE_OATH)
	e3:SetTarget(c12340304.tg)
	e3:SetOperation(c12340304.op)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,12340304+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e4)
end

function c12340304.spfilter(c)
	return c:IsSetCard(0x1205) and c:IsType(TYPE_MONSTER)
end
function c12340304.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c12340304.spfilter,tp,LOCATION_HAND,0,1,c)
end
function c12340304.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c12340304.spfilter,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end

function c12340304.filter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c12340304.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340304.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c12340304.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,c12340304.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end