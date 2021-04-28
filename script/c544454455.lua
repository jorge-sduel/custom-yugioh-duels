--Malefic No. 39 Utopia (ANIME)
function c544454455.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c544454455.spcon)
	e1:SetOperation(c544454455.spop)
	c:RegisterEffect(e1)
	--selfdes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c544454455.descon)
	c:RegisterEffect(e2)
	--disable attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(544454454,0))
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCost(c544454455.negacost)
	e3:SetOperation(c544454455.negaop)
	c:RegisterEffect(e3)
end
function c544454455.spfilter(c)
	return c:IsCode(84013237) and c:IsAbleToGraveAsCost()
end
function c544454455.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c544454455.spfilter,c:GetControler(),LOCATION_EXTRA,0,1,nil)
end
function c544454455.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c544454455.spfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c544454455.descon(e)
	return not Duel.IsEnvironment(27564031)
end
function c544454455.negacostfilter(c)
	return c:IsSetCard(0x23) and c:IsDiscardable()
end
function c544454455.negacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c544454455.negacostfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c544454455.negacostfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c544454455.negaop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
