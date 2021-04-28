--マジカル・アンドロイド
function c129.initial_effect(c)
	--synchro summon
	Xyz.AddProcedure(c,nil,5,2)
	c:EnableReviveLimit()
--pendulum summon
	Pendulum.AddProcedure(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(129,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1)
	e1:SetCost(c129.cost)
	e1:SetCondition(c129.reccon)
	e1:SetTarget(c129.rectg)
	e1:SetOperation(c129.recop)
	c:RegisterEffect(e1,false,REGISTER_FLAG_DETACH_XMAT)
  --Double LP
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(129,2))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(c129.lpcon)
	e2:SetOperation(c129.lpop)
	c:RegisterEffect(e2)
  --effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c129.eftg)
	c:RegisterEffect(e3)
	--to pendulum
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(129,1))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCountLimit(1,129)
	e5:SetCondition(c129.pencon)
	e5:SetTarget(c129.pentg)
	e5:SetOperation(c129.penop)
	c:RegisterEffect(e5)
end
c129.pendulum_level=5
function c129.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c129.reccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c129.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c129.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetMatchingGroupCount(c129.filter,tp,LOCATION_MZONE,0,nil)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ct*500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,ct*500)
end
function c129.recop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c129.filter,tp,0,LOCATION_MZONE,nil)
	Duel.Damage(1-tp,ct*500,REASON_EFFECT)
end
function c129.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(1-tp)>=3000
end
function c129.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)/2)
end
function c129.eftg(e,c)
	return c:IsType(TYPE_MONSTER)
end
function c129.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c129.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(129)==0 and Duel.SelectEffectYesNo(tp,c) then
		Duel.Hint(HINT_CARD,0,c:GetOriginalCode())
		Duel.Hint(HINT_CARD,0,129)
		c:RegisterFlagEffect(129,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
	end
end
function c129.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c129.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end