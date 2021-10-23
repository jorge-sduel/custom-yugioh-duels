--Starving Venemy Dragon
function c46.initial_effect(c)
	c:EnableReviveLimit()
	Pendulum.AddProcedure(c)
	--fusion material
Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_DARK),aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_DARK))
	--reduce
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(46,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c46.rdcon)
	e1:SetOperation(c46.rdop)
	c:RegisterEffect(e1)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_ATKCHANGE+CATEGORY_DAMAGE)
	e2:SetDescription(aux.Stringid(46,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c46.copytg)
	e2:SetOperation(c46.copyop)
	c:RegisterEffect(e2)
	--pendulum
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(90036274,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetTarget(c46.pentg)
	e3:SetOperation(c46.penop)
	c:RegisterEffect(e3)
end
c46.counter_list={0x1149}
c46.listed_series={0x576}
function c46.rdcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and ev>0
end
function c46.rdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(46)==0 and Duel.SelectEffectYesNo(tp,c) then
		Duel.Hint(HINT_CARD,0,46)
		c:RegisterFlagEffect(46,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		Duel.ChangeBattleDamage(tp,0)
	end
end
function c46.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and aux.disfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,aux.disfilter1,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c46.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsType(TYPE_TOKEN) then
		local code=tc:GetOriginalCode()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		if not tc:IsType(TYPE_TRAPMONSTER) then
			local cid=c:CopyEffect(code,RESET_EVENT+0x1fe0000,1)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_UPDATE_ATTACK)
			e3:SetValue(-500)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3)
		end
		Duel.Damage(1-tp,500,REASON_EFFECT)
	end
end
function c46.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c46.desfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c46.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c46.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c46.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
