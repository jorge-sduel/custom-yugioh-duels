--Advanced Crystal Beast Topaz Tiger
function c956000671.initial_effect(c)
	--Also treated as "Crystal Beast Topaz Tiger"
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_CODE)
	e1:SetValue(95600067)
	c:RegisterEffect(e1)
	--Tiger's Fury
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c956000671.furycon)
	e2:SetValue(400)
	c:RegisterEffect(e2)
	--Turn into Crystal
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(956000671,0))
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c956000671.crystaltg)
	e3:SetOperation(c956000671.crystalop)
	c:RegisterEffect(e3)
end
function c956000671.crystaltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetDestination()==LOCATION_GRAVE and c:IsReason(REASON_DESTROY) end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return false end
	return Duel.SelectEffectYesNo(tp,c)
end
function c956000671.crystalop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	Duel.RaiseEvent(c,47408488,e,0,tp,0,0)
end
function c956000671.furycon(e)
	local phase=Duel.GetCurrentPhase()
	return (phase==PHASE_DAMAGE or phase==PHASE_DAMAGE_CAL)
	and Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()~=nil 
	or Duel.GetAttackTarget()==e:GetHandler() and Duel.GetAttackTarget()~=nil
end