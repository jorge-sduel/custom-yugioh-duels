--Malefic Knight Master Diamond (ANIME)
function c544454459.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c544454459.spcon)
	e1:SetOperation(c544454459.spop)
	c:RegisterEffect(e1)
	--selfdes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c544454459.descon)
	c:RegisterEffect(e2)
	--atkup
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EFFECT_UPDATE_ATTACK)
	e9:SetValue(c544454459.atkup)
	c:RegisterEffect(e9)
	--copy
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(544454459,0))
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetCountLimit(1)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCost(c544454459.copycost)
	e10:SetOperation(c544454459.copyop)
	c:RegisterEffect(e10)
end
function c544454459.spfilter(c)
	return c:IsCode(39512984) and c:IsAbleToGraveAsCost()
end
function c544454459.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c544454459.spfilter,c:GetControler(),LOCATION_EXTRA,0,1,nil)
end
function c544454459.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c544454459.spfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c544454459.descon(e)
	return not Duel.IsEnvironment(27564031)
end
function c544454459.atkfilter(c)
	return c:IsSetCard(0x23) and c:IsType(TYPE_MONSTER)
end
function c544454459.atkup(e,c)
	return Duel.GetMatchingGroupCount(c544454459.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*100
end
function c544454459.copyfilter(c)
	return c:IsSetCard(0x23) and c:IsType(TYPE_MONSTER) and not c:IsCode(544454458) and c:IsAbleToRemoveAsCost()
end
function c544454459.copycost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c544454459.copyfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c544454459.copyfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(g:GetFirst():GetOriginalCode())
end
function c544454459.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local code=e:GetLabel()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
		c:CopyEffect(code, RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END, 1)
	end
end