--OverFusion
function c12340124.initial_effect(c)
	c:EnableReviveLimit()
	--overfusion summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCondition(c12340124.hspcon)
	e1:SetOperation(c12340124.hspop)
	e1:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(e1)
	--attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c12340124.atkval)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c12340124.reptg)
	c:RegisterEffect(e3)
    --spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12340124,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCountLimit(1,12340124)
	e4:SetCondition(c12340124.gycon)
	e4:SetTarget(c12340124.gytg)
	e4:SetOperation(c12340124.gyop)
	c:RegisterEffect(e4)
end

function c12340124.hspfilter(c)
	return c:IsType(TYPE_FUSION) and c:GetAttack()<=2500
end
function c12340124.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(e:GetHandlerPlayer(),LOCATION_MZONE)+Duel.GetLocationCountFromEx(e:GetHandlerPlayer(),e:GetHandlerPlayer(),nil,c)>0
        and Duel.IsExistingMatchingCard(c12340124.hspfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c12340124.hspop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c12340124.hspfilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.SendtoGrave(g,REASON_MATERIAL)
    c:SetMaterial(g)
end

function c12340124.atkfilter(c)
	return c:IsType(TYPE_FUSION)
end
function c12340124.atkval(e,c)
	return Duel.GetMatchingGroupCount(c12340124.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*200
end


function c12340124.repfilter(c)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_ZOMBIE)
end
function c12340124.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT)
		and Duel.IsExistingMatchingCard(c12340124.repfilter,e:GetHandlerPlayer(),LOCATION_EXTRA,0,1,nil) end
	if Duel.SelectYesNo(tp,aux.Stringid(12340124,0)) then
        Duel.Destroy(Duel.SelectMatchingCard(tp,c12340124.repfilter,tp,LOCATION_EXTRA,0,1,1,nil),REASON_REPLACE)
		return true
	else return false end
end

function c12340124.gycon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_MZONE) and bit.band(c:GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c12340124.gyfilter(c,e,tp)
	return c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_MONSTER) and c:IsDefenseBelow(0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12340124.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340124.gyfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c12340124.gyop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c12340124.gyfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end