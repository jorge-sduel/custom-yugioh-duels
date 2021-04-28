--xyz protection
function c222.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c222.target)
	e1:SetOperation(c222.operation)
	c:RegisterEffect(e1)
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(1000)
	e2:SetCondition(c222.condition)
	c:RegisterEffect(e2)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetValue(c222.eqlimit)
	c:RegisterEffect(e3)
	--no damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e4:SetCondition(c222.damcon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_EQUIP)
	e5:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e5:SetCountLimit(1)
	e5:SetValue(c222.valcon)
	c:RegisterEffect(e5)
	--atkup
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(95784434,0))
	e6:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EVENT_DAMAGE_STEP_END)
	e6:SetCondition(c222.adcon)
	e6:SetOperation(c222.adop)
	c:RegisterEffect(e6)
	--replace
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_EQUIP)
	e7:SetCode(EFFECT_DESTROY_REPLACE)
	e7:SetTarget(c222.reptg2)
	e7:SetOperation(c222.repop2)
	c:RegisterEffect(e7)
	--destroy
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(222,4))
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e8:SetCode(222)
	e8:SetTarget(c222.xyztg)
	e8:SetOperation(c222.xyzop)
	c:RegisterEffect(e8)
end
function c222.eqlimit(e,c)
	return c:IsType(TYPE_XYZ)
end
function c222.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c222.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c222.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c222.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c222.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c222.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c222.condition(e)
	local phase=Duel.GetCurrentPhase()
	local ec=e:GetHandler():GetEquipTarget()
	local tc=ec:GetBattleTarget()
	return (phase==PHASE_DAMAGE or phase==PHASE_DAMAGE_CAL)
end
function c222.damcon(e)
	return e:GetHandler():GetEquipTarget():GetControler()==e:GetHandlerPlayer()
end
function c222.valcon(e,re,r,rp)
	if bit.band(r,REASON_BATTLE)~=0 then
		e:GetHandler():RegisterFlagEffect(222,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE,0,1)
		return true
	else return false end
end
function c222.adcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(222)~=0
end
function c222.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(100)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:GetEquipTarget():RegisterEffect(e1)
end
function c222.reptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetEquipTarget():IsReason(REASON_BATTLE+REASON_EFFECT) and not c:GetEquipTarget():IsReason(REASON_REPLACE)
		and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		c:SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c222.repop2(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.RaiseSingleEvent(e:GetHandler(),222,re,r,rp,0,0)
end
function c222.xyzfil(c)
	return c:IsType(TYPE_XYZ)
end
function c222.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c222.xyzfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c222.xyzfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c222.xyzfil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c222.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end