--God Hand Impact
function c44782202.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c44782202.condition)
	e1:SetCost(c44782202.cost)
	e1:SetTarget(c44782202.target)
	e1:SetOperation(c44782202.activate)
	c:RegisterEffect(e1)
end
function c44782202.costfilter(c)
	return c:IsFaceup() and not c:IsCode(10000000)
end
function c44782202.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c44782202.costfilter,2,nil) end
	local g=Duel.SelectReleaseGroup(tp,c44782202.costfilter,2,2,nil)
	Duel.Release(g,REASON_COST)
end
function c44782202.cfilter(c)
	return c:IsFaceup() and c:IsCode(10000000)
end
function c44782202.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c44782202.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c44782202.filter(c)
	return c:IsFaceup() and c:IsCode(10000000)
end
function c44782202.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c44782202.filter,tp,LOCATION_MZONE,0,1,nil) end
end
function c44782202.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c44782202.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE+PHASE_END)
		e1:SetValue(9999999)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
