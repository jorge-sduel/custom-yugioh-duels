--Trap
function c12340320.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	e1:SetTarget(c12340320.target)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetLabelObject(e1)
	e2:SetCondition(c12340320.tgcon)
	e2:SetOperation(c12340320.tgop)
	c:RegisterEffect(e2)
	--cannot attack/disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c12340320.ctg)
	c:RegisterEffect(e3)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e5)
	--leave field
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetCondition(c12340320.descon)
	e6:SetOperation(c12340320.desop)
	c:RegisterEffect(e6)
	--to hand
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(12340320,0))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetCountLimit(1,12340320)
	e7:SetCost(c12340320.spcost)
	e7:SetTarget(c12340320.sptg)
	e7:SetOperation(c12340320.spop)
	c:RegisterEffect(e7)
end
function c12340320.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c12340320.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c12340320.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12340320.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c12340320.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c12340320.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject()
end
function c12340320.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):GetFirst()
	if c:IsRelateToEffect(re) and tc:IsFaceup() and tc:IsRelateToEffect(re) then
		c:SetCardTarget(tc)
	end
end
function c12340320.ctg(e,c)
	return e:GetHandler():IsHasCardTarget(c)
end
function c12340320.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_DESTROY_CONFIRMED) then return false end
	local tc=c:GetFirstCardTarget()
	return tc and eg:IsContains(tc)
end
function c12340320.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end

function c12340320.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c12340320.spfilter(c,e,tp)
	return c:IsSetCard(0x205) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c12340320.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340320.spfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c12340320.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12340320.spfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end