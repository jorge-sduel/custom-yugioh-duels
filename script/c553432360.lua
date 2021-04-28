--Sin Red-Eyes Black Dragon
function c553432360.initial_effect(c)
	c:EnableReviveLimit()
	--Special Summon by Sending 1 "Red-Eyes B. Dragon" to the Graveyard
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c553432360.sinsumcon)
	e1:SetOperation(c553432360.sinsumop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(aux.FALSE)
	c:RegisterEffect(e2)
	--If "Sin World" is not Face-Up on the Field, Destroy this Card
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetCondition(c553432360.selfdestroycon)
	c:RegisterEffect(e3)
end
function c553432360.sinsumfilter(c)
	return c:IsCode(74677422) and c:IsAbleToGraveAsCost()
end
function c553432360.sinsumcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c553432360.sinsumfilter,c:GetControler(),LOCATION_DECK,0,1,nil)
end
function c553432360.sinsumop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=Duel.GetFirstMatchingCard(c553432360.sinsumfilter,tp,LOCATION_DECK,0,nil)
	Duel.SendtoGrave(tc,REASON_COST)
end
function c553432360.selfdestroycon(e)
	return not Duel.IsEnvironment(27564031)
end