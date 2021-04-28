--External Worlds Lord
--Scripted by Secuter
function c12340009.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12340009,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,12340009)
	e1:SetCondition(c12340009.cond)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340009,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c12340009.condition)
	e2:SetTarget(c12340009.target)
	e2:SetOperation(c12340009.operation)
	c:RegisterEffect(e2)
end

function c12340009.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x201)
end
function c12340009.filter2(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c12340009.cond(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and	Duel.IsExistingMatchingCard(c12340009.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
		and Duel.GetMatchingGroupCount(c12340009.filter2,c:GetControler(),LOCATION_MZONE,0,nil)==0
end

function c12340009.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattleTarget()
end
function c12340009.tgfilter(c)
	return c:IsSetCard(0x201) and c:IsAbleToRemoveAsCost() and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c12340009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340009.tgfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c12340009.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c12340009.tgfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	local c=e:GetHandler()
	local tc=g:GetFirst()
	if tc and Duel.Remove(tc,POS_FACEUP,REASON_COST)~=0 and tc:IsLocation(LOCATION_REMOVED)
		and c:IsRelateToBattle() and c:IsFaceup() then
		local lv=tc:GetLevel()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(lv*200)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		c:RegisterEffect(e1)
	end
end