--Asura Field
function c12340912.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--activate limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(c12340912.cedcon)
	e2:SetOperation(c12340912.cedop)
	c:RegisterEffect(e2)
	--cannot disable summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCode(EVENT_SUMMON)
	e3:SetOperation(c12340912.chainop)
	c:RegisterEffect(e3)
	--indes
	--local e2=Effect.CreateEffect(c)
	--e2:SetType(EFFECT_TYPE_FIELD)
	--e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	--e2:SetRange(LOCATION_FZONE)
	--e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	--e2:SetTarget(c12340912.target)
	--e2:SetValue(c12340912.effect)
	--c:RegisterEffect(e2)
	--local e3=e2:Clone()
	--e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	--e3:SetValue(c12340912.battle)
	--c:RegisterEffect(e3)
	--Atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(c12340912.effcon)
	e4:SetLabel(2)
	e4:SetValue(c12340912.atkval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e5)
	--to grave
	--local e6=Effect.CreateEffect(c)
	--e6:SetDescription(aux.Stringid(12340912,1))
	--e6:SetCategory(CATEGORY_TOGRAVE)
	--e6:SetType(EFFECT_TYPE_IGNITION)
	--e6:SetRange(LOCATION_FZONE)
	--e6:SetCountLimit(1,12340912+EFFECT_COUNT_CODE_DUEL)
	--e6:SetCondition(c12340912.effcon)
	--e6:SetLabel(6)
	--e6:SetTarget(c12340912.tgtg)
	--e6:SetOperation(c12340912.tgop)
	--c:RegisterEffect(e6)
	--spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetDescription(aux.Stringid(12340912,0))
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCountLimit(1,12340912)
	e6:SetCondition(c12340912.spcon)
	e6:SetTarget(c12340912.sptg)
	e6:SetOperation(c12340912.spop)
	c:RegisterEffect(e6)
end

--anti chain
function c12340912.cedcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst()~=e:GetHandler() and eg:GetFirst():IsSetCard(0x281)
end
function c12340912.cedop(e,tp,eg,ep,ev,re,r,rp)
	eg:GetFirst():RegisterFlagEffect(12340912,RESET_CHAIN,1,1)
	Duel.SetChainLimitTillChainEnd(c12340912.chlimit)--SetChainLimitTillChainEnd
end
function c12340912.chlimit(re,rp,tp)
	return re:GetHandler():GetFlagEffect(12340912)==1
end

--anti negate
function c12340912.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	if rc:IsSetCard(0x281) and (rc:GetSummonType()==SUMMON_TYPE_NORMAL or rc:GetSummonType()==SUMMON_TYPE_ADVANCE) then
		Duel.SetChainLimit(c12340912.chainlm)--SetChainLimit
	end
end
function c12340912.chainlm(e,rp,tp)
	return false
end

function c12340912.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_SZONE) and c:GetPreviousSequence()==5 and c:IsPreviousPosition(POS_FACEUP)
		and rp~=tp and bit.band(r,REASON_EFFECT)==REASON_EFFECT
end
function c12340912.spfilter(c,e,tp)
	return c:IsSetCard(0x281) and c:IsLevelAbove(7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12340912.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c12340912.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c12340912.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c12340912.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c12340912.target(e,c)
	return c:IsLevelAbove(7) and c:IsSummonType(SUMMON_TYPE_NORMAL)
end
function c12340912.effect(e,re)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsAttribute(e:GetHandler():GetAttribute())
end
function c12340912.battle(e,c)
	return not c:IsAttribute(e:GetHandler():GetAttribute())
end

function c12340912.effcon(e)
	local tp=e:GetHandlerPlayer()
	local ct=0
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_MONSTER)
	for i=0,10 do
		local t = math.pow(2, i)
		if g:IsExists(Card.IsAttribute,1,nil,t) then
			ct=ct+1
		end
	end
	return ct>=e:GetLabel()
end

function c12340912.atkval(e,tp,eg,ep,ev,re,r,rp)
	local ct=0
	local g=Duel.GetMatchingGroup(Card.IsType,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil,TYPE_MONSTER)
	for i=0,10 do
		local t = math.pow(2, i)
		if g:IsExists(Card.IsAttribute,1,nil,t) then
			ct=ct+1
		end
	end
	return ct*200
end

function c12340912.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c12340912.tgop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_EXTRA,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end