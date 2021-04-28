--Dark King
function c12340312.initial_effect(c)
	c:EnableReviveLimit()
	--attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c12340312.atkval)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c12340312.distg)
	c:RegisterEffect(e2)
end

function c12340312.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK)
end
function c12340312.atkval(e,c)
	return Duel.GetMatchingGroupCount(c12340312.filter,c:GetControler(),LOCATION_REMOVED,0,nil)*200
end

function c12340312.distg(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsAttackBelow(e:GetHandler():GetAttack()-1)
end