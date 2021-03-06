--Sky Striker Ace - Khamuy
local s,id=GetID()
function s.initial_effect(c)
	--Can only be special summoned once per turn
	c:SetSPSummonOnce(id)
	--Must be properly summoned before reviving
	c:EnableReviveLimit()
	--Link summon procedure
	Link.AddProcedure(c,s.matfilter,1,1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetCountLimit(1)
	e2:SetValue(s.indct)
	c:RegisterEffect(e2)
	--Halve damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetValue(s.val)
	c:RegisterEffect(e4)
	--Halve damage
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCode(EFFECT_CHANGE_DAMAGE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetValue(s.val)
	c:RegisterEffect(e5) 
	--Halve damage
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_CHANGE_DAMAGE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,0)
	e6:SetValue(s.val2)
	c:RegisterEffect(e6)
	--Halve damage
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetCode(EFFECT_CHANGE_DAMAGE)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTargetRange(1,0)
	e7:SetValue(s.val2)
	c:RegisterEffect(e7)
end
s.listed_series={0x115}
function s.indct(e,re,r,rp)
	return (r&REASON_BATTLE+REASON_EFFECT)~=0
end
function s.matfilter(c,scard,sumtype,tp)
	return c:IsSetCard(0x1115,scard,sumtype,tp) and not c:IsAttribute(ATTRIBUTE_EARTH,scard,sumtype,tp)
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetBattleDamage(tp)>=1500 or Duel.GetEffectDamage(tp)>=1500
end
function s.val(e,re,val,r,rp,rc)
	if val<=1500 then return 0 else return val end
end
function s.damcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetBattleDamage(tp)<=1500 or Duel.GetEffectDamage(tp)<=1500
end
function s.val2(e,re,val,r,rp,rc)
	if val>=1501 then return val-1500 else return val end
end
