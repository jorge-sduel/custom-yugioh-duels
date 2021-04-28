--Rainbow Dark Dragon
function c798567921.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,1,798567921)
	--Rainbow Summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c798567921.rainbowcon)
	c:RegisterEffect(e1)
	--Cannot be Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)
	--Rainbow Dark Overdrive
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetDescription(aux.Stringid(798567921,0))
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(TIMING_DAMAGE_STEP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c798567921.overdrivecost)
	e3:SetOperation(c798567921.overdriveop)
	c:RegisterEffect(e3)
	--Crystal Protection
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetDescription(aux.Stringid(798567921,1))
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetCondition(c798567921.protectioncon)
	e4:SetTarget(c798567921.protectiontg)
	e4:SetOperation(c798567921.protectionop)
	c:RegisterEffect(e4)
	--Activation Limited
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetOperation(c798567921.limited)
	c:RegisterEffect(e5)
end
function c798567921.rainbowfilter(c)
	return c:IsSetCard(0x1034) and (not c:IsOnField() or c:IsFaceup())
end
function c798567921.rainbowcon(e,c)
	if c==nil then return true end
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)<=0 then return false end
	local g=Duel.GetMatchingGroup(c798567921.rainbowfilter,c:GetControler(),LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	return ct>6
end
function c798567921.overdrivecon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(798567921)~=0 then return false end
	local phase=Duel.GetCurrentPhase()
	return phase~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c798567921.overdrivefilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1034) and c:IsAbleToGraveAsCost()
end
function c798567921.overdrivecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c798567921.overdrivefilter,tp,LOCATION_MZONE+LOCATION_SZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c798567921.overdrivefilter,tp,LOCATION_MZONE+LOCATION_SZONE,0,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetCount())
end
function c798567921.overdriveop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel()*1000)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
function c798567921.protectioncon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(798567921)==0
end
function c798567921.protectionfilter(c)
	return c:IsSetCard(0x1034) and c:IsAbleToGraveAsCost()
end
function c798567921.protectiontg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c798567921.protectionfilter,tp,LOCATION_SZONE,0,1,nil) end
	return Duel.SelectYesNo(tp,aux.Stringid(798567921,1))
end
function c798567921.protectionop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c798567921.protectionfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c798567921.limited(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(798567921,RESET_EVENT+0xfc0000+RESET_PHASE+PHASE_END,0,1)
end