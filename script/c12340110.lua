--Undead
function c12340110.initial_effect(c)
    --cannot Set
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_LIMIT_SET_PROC)
	e6:SetCondition(c12340110.setcon)
	c:RegisterEffect(e6)
    --return to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHANGE_POS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c12340110.hdcon)
	e3:SetOperation(c12340110.hdop)
	c:RegisterEffect(e3)
    local e4=e3:Clone()
	e4:SetCode(EVENT_CHANGE_POS)
	c:RegisterEffect(e4)
    local e5=e3:Clone()
	e5:SetCode(EVENT_BATTLE_END)
	c:RegisterEffect(e5)
	--special summon in atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c12340110.con)
	e1:SetOperation(c12340110.op)
	c:RegisterEffect(e1)
    --to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340110,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,12340110)
	e2:SetCondition(c12340110.gycond)
	e2:SetTarget(c12340110.gytg)
	e2:SetOperation(c12340110.gyop)
	c:RegisterEffect(e2)
end

function c12340110.setcon(e,c,minc)
	if not c then return true end
	return false
end

function c12340110.hdcon(e)
	return e:GetHandler():IsPosition(POS_FACEUP_DEFENSE)
end
function c12340110.hdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end

function c12340110.con(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():IsPosition(POS_ATTACK)
end
function c12340110.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_ATTACK)
    c:RegisterEffect(e2)
end

function c12340110.gycond(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD)
end
function c12340110.filter(c,e,tp)
	return c:IsSetCard(0x202) and c:IsRace(RACE_ZOMBIE) and c:IsAttackBelow(0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(12340110)
end
function c12340110.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340110.filter,tp,LOCATION_GRAVE,0,2,nil,e,tp)
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end
function c12340110.gyop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c12340110.filter,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		tc=g:GetNext()
    end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c12340110.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c12340110.splimit(e,c)
	return not c:IsRace(RACE_ZOMBIE)
end