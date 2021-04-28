--Dark King
function c12340311.initial_effect(c)
	c:EnableReviveLimit()
	--attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c12340311.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--activate limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c12340311.actcon)
	e3:SetValue(c12340311.aclimit)
	c:RegisterEffect(e3)
end

function c12340311.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK)
end
function c12340311.atkval(e,c)
	return Duel.GetMatchingGroupCount(c12340311.filter,c:GetControler(),LOCATION_REMOVED,0,nil)*200
end

function c12340311.actcon(e)
	local tc=Duel.GetAttacker()
	local tp=e:GetHandlerPlayer()
	return tc and tc:IsControler(tp) and tc:IsType(TYPE_RITUAL)
end
function c12340311.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end