--External Worlds Dark Tuner
--Scripted by Secuter
function c12340024.initial_effect(c)
	c:EnableReviveLimit()
	--special summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,12340024+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c12340024.spcon)
	e2:SetOperation(c12340024.spop)
	c:RegisterEffect(e2)
	--change lv
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12340024,1))
	e3:SetCategory(CATEGORY_LVCHANGE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c12340024.condition)
	e3:SetTarget(c12340024.target)
	e3:SetOperation(c12340024.operation)
	c:RegisterEffect(e3)
    --pendulum
	aux.EnablePendulumAttribute(c)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12340024,0))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1,12340024)
	e4:SetCondition(c12340024.con)
	e4:SetTarget(c12340024.tg)
	e4:SetOperation(c12340024.op)
	c:RegisterEffect(e4)
end

function c12340024.spfilter(c)
	return c:IsSetCard(0x201) and c:IsFaceup()
end
function c12340024.spcon(e,c)
	if c==nil then return true end
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)<=0 then return false end
	local g=Duel.GetMatchingGroup(c12340024.spfilter,c:GetControler(),LOCATION_EXTRA,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>=3
end
function c12340024.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c12340024.spfilter,tp,LOCATION_EXTRA,0,nil)
	local rg=Group.CreateGroup()
	for i=1,3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc then
			rg:AddCard(tc)
			g:Remove(Card.IsCode,nil,tc:GetCode())
		end
	end
	Duel.SendtoGrave(rg,REASON_COST)
end

function c12340024.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_PZONE,0,1,e:GetHandler(),0x201)
end
function c12340024.pfilter(c,e,tp)
	return c:IsSetCard(0x201) and c:IsFaceup() and not c:IsCode(12340024) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12340024.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable()	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c12340024.pfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c12340024.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c12340024.pfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetTarget(c12340024.splimit)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function c12340024.splimit(c)
	return not c:IsLocation(LOCATION_REMOVED)
end

function c12340024.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)--:GetSummonType()==SUMMON_TYPE_SPECIAL+1
end
function c12340024.filter(c)
	return c:IsFaceup() and c:GetLevel()~=0
end
function c12340024.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c12340024.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12340024.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c12340024.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c12340024.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end