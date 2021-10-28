--突撃ライノス
local s,id=GetID()
function s.initial_effect(c)
	--move
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(aux.seqmovcon)
	e1:SetOperation(aux.seqmovop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetCondition(s.atkcon)
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetCondition(s.lvcon)
	e3:SetValue(s.lvval)
	c:RegisterEffect(e3)
--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetCondition(s.lvcon2)
	e4:SetValue(s.lvval2)
	c:RegisterEffect(e4)
--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_ADD_TYPE)
	e5:SetCondition(s.lvcon3)
	e5:SetValue(s.lvval3)
	c:RegisterEffect(e5)
end
s.levels={5,4,6,3,8}
s.attacks={1000,0,0,0,0}
s.types={0,TYPE_TUNER,0,TYPE_TUNER,0}
function s.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()<5
end
function s.lvval(e,tp,eg,ep,ev,re,r,rp)
	return s.levels[e:GetHandler():GetSequence()+1]
end
function s.lvcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()<5
end
function s.lvval2(e,tp,eg,ep,ev,re,r,rp)
	return s.attacks[e:GetHandler():GetSequence()+1]
end
function s.lvcon3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSequence()<5
end
function s.lvval3(e,tp,eg,ep,ev,re,r,rp)
	return s.types[e:GetHandler():GetSequence()+1]
end
function s.atkval(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttack()*2
end
function s.atkcon(e)
	local ph=Duel.GetCurrentPhase()
	local c=e:GetHandler()
	local at=Duel.GetAttackTarget()
	if (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and Duel.GetAttacker()==c and at then
		return c:GetColumnGroup():IsContains(at)
	else return false end
end
