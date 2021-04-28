--Invoker
function c86123077.initial_effect(c)
	c:EnableReviveLimit()
	--over fusion summon
	local over=Effect.CreateEffect(c)
	over:SetType(EFFECT_TYPE_FIELD)
	over:SetCode(EFFECT_SPSUMMON_PROC)
	over:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	over:SetRange(LOCATION_HAND)
	over:SetCondition(c86123077.hspcon)
	over:SetOperation(c86123077.hspop)
	c:RegisterEffect(over)
	--change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(86123077)
	c:RegisterEffect(e1)
	--boost
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(86123077,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+0x1c0)
	e2:SetCondition(c86123077.adcon)
	e2:SetCost(c86123077.adcost)
	e2:SetOperation(c86123077.adop)
	c:RegisterEffect(e2)
	--destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c86123077.reptg)
	e3:SetOperation(c86123077.repop)
	c:RegisterEffect(e3)
end

function c86123077.hspfilter(c)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xf4)
end
function c86123077.hspcon(e,c)
	if c==nil then return true end
	return (Duel.GetLocationCount(e:GetHandlerPlayer(),LOCATION_MZONE)+Duel.GetLocationCountFromEx(e:GetHandlerPlayer(),e:GetHandlerPlayer(),nil,c))>0
        and Duel.IsExistingMatchingCard(c86123077.hspfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c86123077.hspop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c86123077.hspfilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.Overlay(c,g)
    c:SetMaterial(g)
	--search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(86123077,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(c86123077.thtg)
	e4:SetOperation(c86123077.thop)
	c:RegisterEffect(e4)
end

function c86123077.thfilter(c)
	return (c:IsCode(47457347) or c:IsCode(00458748)) and c:IsAbleToHand()
end
function c86123077.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c86123077.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c86123077.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c86123077.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c86123077.adfilter(c)
	return c:IsSetCard(0xf4) and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_GRAVE) and c:IsAbleToRemoveAsCost()
end
function c86123077.adcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c86123077.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c86123077.adfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c86123077.adfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c86123077.filter(e,c)
	return c:IsType(TYPE_FUSION) or c:IsSetCard(0x431)
end
function c86123077.adop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(c86123077.filter)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	Duel.RegisterEffect(e2,tp)
end

function c86123077.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c86123077.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
end