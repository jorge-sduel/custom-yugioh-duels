--Raging Fighter
function c86123677.initial_effect(c)
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,c86123677.xyzfilter,nil,2,nil,nil,nil,nil,false,c86123677.xyzcheck)
	--attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(86123677,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_BATTLE_PHASE)
	e2:SetCondition(c86123677.condition)
	e2:SetCost(c86123677.cost)
	e2:SetTarget(c86123677.target)
	e2:SetOperation(c86123677.operation)
	c:RegisterEffect(e2,false,1)
end
function c86123677.xyzfilter(c,xyz,sumtype,tp)
	return c:IsType(TYPE_MONSTER,xyz,sumtype,tp) and (c:IsXyzLevel(2) or c:IsXyzLevel(4))
end
function c86123677.xyzcheck(g,tp,xyz)
	local mg=g:Filter(function(c) return not c:IsHasEffect(511001175) end,nil)
	return mg:GetClassCount(Card.GetLevel)~=1 or c:IsHasEffect(511001225)
end
function c86123677.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) and at and ((a:IsControler(tp) and a:IsOnField())
		or (at:IsControler(tp) and at:IsOnField() and at:IsFaceup()))
end
function c86123677.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,86123677)==0 and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.RegisterFlagEffect(tp,86123677,RESET_PHASE+PHASE_DAMAGE,0,1)
end
function c86123677.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(Duel.GetAttacker())
	Duel.SetTargetCard(Duel.GetAttackTarget())
end
function c86123677.operation(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	if at:IsControler(tp) then a,at=at,a end
	if a:IsFacedown() or not a:IsRelateToEffect(e) or not at:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	a:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e2:SetValue(1)
	e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
	a:RegisterEffect(e2,true)
end
