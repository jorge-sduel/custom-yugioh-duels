--Fusion Master of Skulls
function c12340117.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	Fusion.AddProcMix(c,true,true,aux.FilterBoolFunction(Card.IsFusionSetCard,0x202),aux.FilterBoolFunctionEx(Card.IsAttackBelow,1))
    --sent to GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340117,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,12340117)
	e2:SetCondition(c12340117.gycon)
	e2:SetTarget(c12340117.gytg)
	e2:SetOperation(c12340117.gyop)
	c:RegisterEffect(e2)
end

function c12340117.gycon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and bit.band(c:GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c12340117.filter(c)
	return c:IsSetCard(0x202) and c:IsAbleToHand()
end
function c12340117.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340117.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c12340117.gyop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12340117.filter,tp,LOCATION_GRAVE,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end