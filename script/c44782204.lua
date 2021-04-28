--Divine Conflict
function c44782204.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)	
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(c44782204.condition)
	e1:SetCost(c44782204.cost)
	e1:SetOperation(c44782204.activate)
	c:RegisterEffect(e1)
end
function c44782204.cfilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DEVINE)
end
function c44782204.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c44782204.cfilter,tp,LOCATION_MZONE,0,1,nil) 
		and Duel.IsExistingMatchingCard(c44782204.cfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c44782204.afilter(c)
	return not c:IsAttribute(ATTRIBUTE_DEVINE) and c:IsAbleToGraveAsCost()
end
function c44782204.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c44782204.afilter,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE+LOCATION_HAND,1,nil) end
	local g=Duel.GetMatchingGroup(c44782204.afilter,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE+LOCATION_HAND,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetCount())
end
function c44782204.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_SZONE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(c44782204.atkfil1)
		e1:SetValue(e:GetLabel()*1000)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetRange(LOCATION_SZONE)
		e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e2:SetTarget(c44782204.atkfil2)
		e2:SetValue(e:GetLabel()*2000)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
	end
end
function c44782204.atkfil1(e,c)
	return c:IsAttribute(ATTRIBUTE_DEVINE) and not c:IsCode(10000020)
end
function c44782204.atkfil2(e,c)
	return c:IsCode(10000020)
end