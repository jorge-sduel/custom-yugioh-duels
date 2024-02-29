--
local s,id=GetID()
function s.initial_effect(c)
	c:AddSetcodesRule(id,false,0x601)
	--dark synchro summon
	c:EnableReviveLimit()
	Synchro.AddDarkSynchroProcedure(c,Synchro.NonTuner(nil),nil,10)
	--There can only be 1 "Earthbound Immortal" on the field
	c:SetUniqueOnField(1,1,aux.FilterBoolFunction(Card.IsSetCard,SET_EARTHBOUND_IMMORTAL),LOCATION_MZONE)
	--Can attack directly
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetCondition(s.sdcon)
	c:RegisterEffect(e1)
	--Cannot be targeted for attacks
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.sdcon)
	e2:SetValue(aux.imval2)
	c:RegisterEffect(e2)
	--Can attack directly
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e4)
	--poschange
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SET_POSITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetValue(POS_FACEUP_DEFENSE)
	e5:SetTarget(s.efcon)
	c:RegisterEffect(e5)
	--disable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,LOCATION_MZONE)
	e6:SetCode(EFFECT_DISABLE)
	e6:SetTarget(s.efcon2)
	c:RegisterEffect(e6)
	--disable
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(0,LOCATION_MZONE)
	e7:SetCode(EFFECT_CANNOT_ATTACK)
	e7:SetTarget(s.efcon2)
	c:RegisterEffect(e7)
	--Cannot be targeted for attacks
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetValue(aux.imval2)
	c:RegisterEffect(e8)
end
s.listed_series={SET_EARTHBOUND_IMMORTAL}
function s.sdcon(e)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,0,LOCATION_FZONE,0,1,nil)
end
function s.efcon(e,c)
	return c:IsAttackBelow(e:GetHandler():GetAttack()) 
end
function s.efcon2(e,c)
	return c:IsHasEffect(EFFECT_CANNOT_CHANGE_POS_E) or c:IsType(TYPE_LINK)
end
