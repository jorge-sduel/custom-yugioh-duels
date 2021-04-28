--スキルドレイン
function c5293241.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE)
	e1:SetCost(c5293241.cost)
	e1:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c5293241.disable)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
end

function c5293241.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e1:SetTarget(c5293241.distarget)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--disable effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetOperation(c5293241.disoperation)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end	

function c5293241.disable(e,c)
	return c:IsType(TYPE_EFFECT)
end
function c5293241.cost(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingMatchingCard(c5293241.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c5293241.cfilter,1,1,REASON_COST+REASON_DISCARD,e:GetHandler())
end
function c5293241.cfilter(c)
	return c:IsDiscardable()
end

function c5293241.distarget(e,c)
	return c~=e:GetHandler() and c:IsType(TYPE_EFFECT)
end
function c5293241.disoperation(e,tp,eg,ep,ev,re,r,rp)
	local tl=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if tl==LOCATION_MZONE and re:IsActiveType(TYPE_EFFECT) then
		Duel.NegateEffect(ev)
	end
end
