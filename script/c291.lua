--重力
function c291.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_EQUIP)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetTarget(c291.target)
	e0:SetOperation(c291.operation)
	c:RegisterEffect(e0)
	--Equip limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c291.descon)
	e1:SetOperation(c291.desop)
	c:RegisterEffect(e1)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(c291.spcon)
	e3:SetValue(c291.atkval)
	c:RegisterEffect(e3)
end
function c291.eqlimit(e,c)
	return c:IsType(TYPE_MONSTER)
end
function c291.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c291.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c158.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c291.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c291.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c291.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
			e:GetHandler():SetTurnCounter(0)
	end
end
function c291.descon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c291.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()+1
	e:GetHandler():SetTurnCounter(ct)
	e:SetLabel(ct)
	if not c:IsLocation(LOCATION_SZONE) then
			e:GetHandler():SetTurnCounter(0)
		c:ResetFlagEffect(1082946)
		if re then re:Reset() end
	end
end
function c291.spcon(e,c)
	if c==nil then return true end
	return c:GetTurnCounter()>0
end
function c291.atkval(e,c)
	return e:GetHandler():GetTurnCounter()*300
end