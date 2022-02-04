--Blue Storm Dragon, Maelstrom
function c908.initial_effect(c)
	--Limit Break
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(807,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(c908.condition)
	e1:SetCost(c908.cost)
	e1:SetTarget(c908.target)
	e1:SetOperation(c908.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(908,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c908.atcon)
	e2:SetValue(500)
	c:RegisterEffect(e2)
end
function c908.condition(e)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	return ((c==Duel.GetAttacker() and tc)) and Duel.GetLP(e:GetHandlerPlayer())<4001
end
function c908.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c908.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) 
	and Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c908.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c908.atcon(e)
	local c=e:GetHandler()
	local tc=Duel.GetAttackTarget()
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and ((c==Duel.GetAttacker() and tc))
	and Duel.GetLP(e:GetHandlerPlayer())<4001
end