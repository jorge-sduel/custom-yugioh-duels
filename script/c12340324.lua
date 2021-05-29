--Reunion
function c12340324.initial_effect(c)
		c:EnableReviveLimit()
	--fusion material	
Fusion.AddProcFunRep(c,aux.FilterBoolFunction(Card.IsType,TYPE_RITUAL),3,true)
	--attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c12340324.atkval)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340324,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c12340324.cost)
	e2:SetTarget(c12340324.target)
	e2:SetOperation(c12340324.operation)
	c:RegisterEffect(e2)
	--as ritual
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e3:SetCode(EFFECT_ADD_TYPE)
	e3:SetValue(TYPE_RITUAL)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetTarget(c12340324.distg)
	c:RegisterEffect(e4)
end

function c12340324.afilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK)
end
