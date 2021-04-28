--Malefic No. 39 Utopia
function c544454454.initial_effect(c)
	c:SetUniqueOnField(1,1,aux.FilterBoolFunction(Card.IsSetCard,0x23),LOCATION_MZONE)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c544454454.spcon)
	e1:SetOperation(c544454454.spop)
	c:RegisterEffect(e1)
	--selfdes
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_SELF_DESTROY)
	e7:SetCondition(c544454454.descon)
	c:RegisterEffect(e7)
	--cannot announce
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetTarget(c544454454.antarget)
	c:RegisterEffect(e8)
	--disable attack
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(544454454,0))
	e9:SetCode(EVENT_BE_BATTLE_TARGET)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e9:SetCost(c544454454.negacost)
	e9:SetOperation(c544454454.negaop)
	c:RegisterEffect(e9)
end
function c544454454.spfilter(c)
	return c:IsCode(84013237) and c:IsAbleToRemoveAsCost()
end
function c544454454.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c544454454.spfilter,c:GetControler(),LOCATION_EXTRA,0,1,nil)
end
function c544454454.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=Duel.GetFirstMatchingCard(c544454454.spfilter,tp,LOCATION_EXTRA,0,nil)
	Duel.Remove(tc,POS_FACEUP,REASON_COST)
end
function c544454454.descon(e)
	local f1=Duel.GetFieldCard(0,LOCATION_SZONE,5)
	local f2=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	return (f1==nil or f1:IsFacedown()) and (f2==nil or f2:IsFacedown())
end
function c544454454.antarget(e,c)
	return c~=e:GetHandler()
end
function c544454454.negacostfilter(c)
	return c:IsSetCard(0x23) and c:IsDiscardable()
end
function c544454454.negacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c544454454.negacostfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c544454454.negacostfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c544454454.negaop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
