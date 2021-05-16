--Mist Wyvern
function c82353467.initial_effect(c)

	--Negate Attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82353467,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c82353467.condition)
	e1:SetOperation(c82353467.operation)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
end

--Negate Attack condition
function c82353467.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_BATTLE and
			e:GetHandler():IsPosition(POS_FACEUP_ATTACK)
end

--Negate Attack operation
function c82353467.operation(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsPosition(POS_FACEUP_ATTACK) then return end
	Duel.ChangePosition(c,POS_FACEUP_DEFENCE,POS_FACEDOWN_DEFENCE,0,0)
	Duel.NegateAttack()
end
