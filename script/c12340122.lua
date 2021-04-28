--OverFusion
function c12340122.initial_effect(c)
	c:EnableReviveLimit()
	--overfusion summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCondition(c12340122.hspcon)
	e1:SetOperation(c12340122.hspop)
	e1:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(e1)
	--attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c12340122.atkval)
	c:RegisterEffect(e2)
	--sp summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12340122,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c12340122.cost)
	e3:SetTarget(c12340122.target)
	e3:SetOperation(c12340122.operation)
	c:RegisterEffect(e3)
	--once per duel
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12340122,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,12340122+EFFECT_COUNT_CODE_DUEL)
	e4:SetCondition(c12340122.thcon)
	e4:SetTarget(c12340122.thtg)
	e4:SetOperation(c12340122.thop)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e5:SetValue(c12340122.indesval)
	c:RegisterEffect(e5)
end

function c12340122.hspfilter(c)
	return c:IsType(TYPE_FUSION) and c:GetAttack()>=4000
end
function c12340122.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(e:GetHandlerPlayer(),LOCATION_MZONE)+Duel.GetLocationCountFromEx(e:GetHandlerPlayer(),e:GetHandlerPlayer(),nil,c)>0
        and Duel.IsExistingMatchingCard(c12340122.hspfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c12340122.hspop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c12340122.hspfilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_MATERIAL)
    c:SetMaterial(g)
end

function c12340122.atkfilter(c)
	return c:IsType(TYPE_FUSION)
end
function c12340122.atkval(e,c)
	return Duel.GetMatchingGroupCount(c12340122.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*400
end

function c12340122.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c12340122.rfilter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c12340122.rfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c12340122.rfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_ZOMBIE)
end
function c12340122.filter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12340122.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c12340122.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0    
        and Duel.IsExistingMatchingCard(c12340122.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c12340122.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c12340122.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
	end
end

function c12340122.cfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsSummonType(SUMMON_TYPE_FUSION) and c:IsRace(RACE_ZOMBIE) and c:IsControler(tp)
end
function c12340122.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c12340122.cfilter,1,nil,tp)
end
function c12340122.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c12340122.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end

function c12340122.indesval(e,re)
	return re:IsActiveType(TYPE_MONSTER)
end