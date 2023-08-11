--Core Unit Assault
function c989512323.initial_effect(c)
	--Rune Summon
	c:EnableReviveLimit()
	aux.AddRuneProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),1,1,aux.FilterBoolFunction(Card.IsType,TYPE_EQUIP),1,1)
	--Attack Up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(500)
	e1:SetCondition(c989512323.atkcon)
	c:RegisterEffect(e1)
	--Indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(c989512323.indtg)
	e2:SetValue(c989512323.indval)
	c:RegisterEffect(e2)
end
function c989512323.atkcon(e)
	return e:GetHandler():GetEquipCount()>0
end
function c989512323.indtg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c989512323.indval(e,re,tp)
	return e:GetHandler():GetControler()~=tp
end
