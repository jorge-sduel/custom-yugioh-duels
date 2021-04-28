--Sin Cyber End Dragon
function c17104760.initial_effect(c)
	c:EnableReviveLimit()
	--Special Summon by Sending 1 "Cyber End Dragon" to the Graveyard
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c17104760.sinsumcon)
	e1:SetOperation(c17104760.sinsumop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(aux.FALSE)
	c:RegisterEffect(e2)
	--Eternal Evolution Burst
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)
	--If "Malefic World" is not Face-Up on the Field, Destroy this Card
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_SELF_DESTROY)
	e4:SetCondition(c17104760.selfdestroycon)
	c:RegisterEffect(e4)
end
function c17104760.sinsumfilter(c)
	return c:IsCode(1546123) and c:IsAbleToGraveAsCost()
end
function c17104760.sinsumcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c17104760.sinsumfilter,c:GetControler(),LOCATION_EXTRA,0,1,nil)
end
function c17104760.sinsumop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=Duel.GetFirstMatchingCard(c17104760.sinsumfilter,tp,LOCATION_EXTRA,0,nil)
	Duel.SendtoGrave(tc,REASON_COST)
end
function c17104760.selfdestroycon(e)
	return not Duel.IsEnvironment(27564031)
end