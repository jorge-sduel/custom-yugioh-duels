--Ancient Oracle Extra
function c12341422.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	Link.AddProcedure(c,aux.True,2,2,c12341422.lcheck)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCondition(c12341422.effcon)
	e1:SetTarget(c12341422.tgtg)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12341422,0))
	e2:SetCategory(CATEGORY_DECKDES+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,12341422)
	e2:SetCost(c12341422.cost)
	e2:SetOperation(c12341422.op)
	c:RegisterEffect(e2)
end
function c12341422.lcheck(g,lc)
	return g:IsExists(Card.IsSetCard,1,nil,0x211)
end

function c12341422.cfilter(c)
	return c:IsFaceup() and c:IsCode(12341414)
end
function c12341422.effcon(e)
	return Duel.IsExistingMatchingCard(c12341422.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c12341422.tgtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end

function c12341422.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,2) end
	Duel.DiscardDeck(tp,2,REASON_COST)
end
function c12341422.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x211))
	e1:SetValue(500)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN)
	Duel.RegisterEffect(e1,tp)
end