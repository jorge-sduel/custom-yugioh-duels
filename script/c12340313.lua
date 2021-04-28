--Dark King
function c12340313.initial_effect(c)
	c:EnableReviveLimit()
	--attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c12340313.atkval)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
    --attack all
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end

function c12340313.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK)
end
function c12340313.atkval(e,c)
	return Duel.GetMatchingGroupCount(c12340313.filter,c:GetControler(),LOCATION_REMOVED,0,nil)*200
end