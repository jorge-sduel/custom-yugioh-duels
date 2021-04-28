--CX 冀望皇バリアン
function c244.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,7,3,nil,nil,5)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(67926903,0))
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c244.xyzcon)
	e0:SetOperation(c244.xyzop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c244.atkval)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12744567,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c244.condition)
	e2:SetTarget(c244.target)
	e2:SetOperation(c244.operation)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
e3:SetDescription(aux.Stringid(12340417,8))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCondition(c244.condition2)
	e3:SetCost(c244.cost)
	e3:SetTarget(c244.tg2)
	e3:SetOperation(c244.operation2)
	c:RegisterEffect(e3)
	local e10=e3:Clone()
e10:SetDescription(aux.Stringid(12340417,2))
	e10:SetCost(c244.cost2)
	c:RegisterEffect(e10)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(20785975,0))
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c244.cost)
	e4:SetCondition(c244.condition3)
	e4:SetTarget(c244.target3)
	e4:SetOperation(c244.operation3)
	c:RegisterEffect(e4)
	local e11=e4:Clone()
e11:SetDescription(aux.Stringid(12340417,3))
	e11:SetCost(c244.cost2)
	c:RegisterEffect(e11)
		--negate activate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(49456901,1))
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_HANDES)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_CHAINING)
	e5:SetCondition(c244.condition4)
	e5:SetCost(c244.cost)
	e5:SetTarget(c244.target4)
	e5:SetOperation(c244.operation4)
	c:RegisterEffect(e5)
	local e12=e5:Clone()
e12:SetDescription(aux.Stringid(12340417,4))
	e12:SetCost(c244.cost2)
	c:RegisterEffect(e12)
		--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e6:SetDescription(aux.Stringid(85121942,1))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCost(c244.cost)
	e6:SetCondition(c244.condition5)
	e6:SetTarget(c244.destg)
	e6:SetOperation(c244.desop)
	c:RegisterEffect(e6)
	local e13=e6:Clone()
e13:SetDescription(aux.Stringid(12340417,5))
	e13:SetCost(c244.cost2)
	c:RegisterEffect(e13)
	--Negate
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(55888045,0))
	e7:SetCategory(CATEGORY_DISABLE)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCost(c244.cost)
	e7:SetCondition(c244.condition6)
	e7:SetTarget(c244.distg)
	e7:SetOperation(c244.disop)
	c:RegisterEffect(e7)
	local e14=e7:Clone()
e14:SetDescription(aux.Stringid(12340417,6))
	e14:SetCost(c244.cost2)
	c:RegisterEffect(e14)
	--negate
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(799183,0))
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1)
	e8:SetCost(c244.cost)
	e8:SetCondition(c244.condition7)
	e8:SetOperation(c244.negop)
	c:RegisterEffect(e8)
	local e15=e8:Clone()
e15:SetDescription(aux.Stringid(12340417,7))
	e15:SetCost(c244.cost2)
	c:RegisterEffect(e15)
end
function c244.ovfilter(c)
	local code=c:GetCode()
	local class=_G["c"..code]
	if class==nil then return false end
	local no=class.xyz_number
	return c:IsFaceup() and no and no>=101 and no<=107 and c:IsSetCard(0x1048)
end
function c244.xyzcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c244.ovfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if mg:GetCount()<=0 then return false end
	if mg:IsExists(Card.IsControler,1,nil,tp) then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
	else
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
end
function c244.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	og=Group.CreateGroup()
	local mg=Duel.GetMatchingGroup(c244.ovfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	og:Merge(mg)
	local tc=mg:GetFirst()
	while tc do
		local ov=tc:GetOverlayGroup()
		if ov:GetCount()>0 then
			Duel.Overlay(c,ov)
			og:Merge(ov)
		end
		tc=mg:GetNext()
	end
	c:SetMaterial(og)
	Duel.Overlay(c,og)
end
function c244.atkval(e,c)
	return c:GetOverlayCount()*1000
end
function c244.filter(c)
	return not c:IsType(TYPE_TOKEN) and c:IsAbleToChangeControler()
end
function c244.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c244.filter(chkc) end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) 
		and Duel.IsExistingTarget(c244.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c244.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c244.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		local og=tc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function c244.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,12744567)
end
function c244.condition2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,67173574)
end
function c244.condition3(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,20785975)
end
function c244.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c244.filter2(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function c244.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c67173574.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c244.filter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c244.filter2,tp,0,LOCATION_MZONE,1,1,nil)
end
function c244.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetAttack()>0 and tc:IsControler(1-tp) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
	end
end
function c244.filter3(c)
	return c:IsFaceup() and not c:IsAttack(c:GetBaseAttack()) and c:IsAbleToRemove()
end
function c244.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c20785975.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c244.filter3,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c244.filter3,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	local atk=math.abs(tc:GetAttack()-tc:GetBaseAttack())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,1,1-tp,atk)
end
function c244.operation3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local atk=math.abs(tc:GetAttack()-tc:GetBaseAttack())
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and Duel.Damage(1-tp,atk,REASON_EFFECT)~=0 then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c244.condition4(e,tp,eg,ep,ev,re,r,rp,chk)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,49456901)
end
function c244.condition5(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,85121942)
end
function c244.condition6(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,55888045)
end
function c244.condition7(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,68396121)
end
function c244.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c244.operation4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		Duel.BreakEffect()
		local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0):RandomSelect(1-tp,1)
		if Duel.SendtoGrave(g,REASON_EFFECT)>0 then
			Duel.SetLP(1-tp,Duel.GetLP(1-tp)/2)
		end
	end
end
function c244.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetFirst():GetAttack())
end
function c244.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
		local atk=tc:GetAttack()
		if atk<0 or tc:IsFacedown() then atk=0 end
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.Damage(1-tp,atk,REASON_EFFECT)
		end
	end
end
function c244.filter6(c)
	return c:IsFaceup() and not c:IsDisabled()
end
function c244.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c244.filter6,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
end
function c244.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c244.filter6,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
function c244.filter(c)
	return c:IsFaceup() and (c:IsLocation(LOCATION_SZONE) or c:IsType(TYPE_EFFECT)) and not c:IsDisabled()
end
function c244.retfilter(c)
	return c:GetFlagEffect(244)>0
end
function c244.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dg=Duel.GetMatchingGroup(aux.disfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	local tc=dg:GetFirst()
	local nochk=false
	while tc do
		if not nochk then nochk=true end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
		tc=dg:GetNext()
	end
	local rg=Duel.GetMatchingGroup(c244.retfilter,tp,0x7e,0x7e,e:GetHandler())
	local rc=rg:GetFirst()
	while rc do
		if not nochk then nochk=true end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		rc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		rc:RegisterEffect(e2)
		if rc:GetFlagEffectLabel(511010208)==LOCATION_HAND then
			Duel.SendtoHand(rc,rc:GetFlagEffectLabel(511010209),REASON_EFFECT)
		elseif rc:GetFlagEffectLabel(511010208)==LOCATION_GRAVE then
			Duel.SendtoGrave(rc,REASON_EFFECT,rc:GetFlagEffectLabel(511010209))
		elseif rc:GetFlagEffectLabel(511010208)==LOCATION_REMOVED then
			Duel.Remove(rc,rc:GetPreviousPosition(),REASON_EFFECT,rc:GetFlagEffectLabel(511010209))
		elseif rc:GetFlagEffectLabel(511010208)==LOCATION_DECK then
			Duel.SendtoDeck(rc,rc:GetFlagEffectLabel(511010209),2,REASON_EFFECT)
		elseif rc:GetFlagEffectLabel(511010208)==LOCATION_EXTRA then
			Duel.SendtoDeck(rc,rc:GetFlagEffectLabel(511010209),0,REASON_EFFECT)
		else
			Duel.MoveToField(rc,rc:GetFlagEffectLabel(511010209),rc:GetFlagEffectLabel(511010209),rc:GetFlagEffectLabel(511010208),rc:GetFlagEffectLabel(511010210),true)
			if rc:GetSequence()~=rc:GetFlagEffectLabel(511010211) then
				Duel.MoveSequence(rc,rc:GetFlagEffectLabel(511010211))
			end
		end
		rc=rg:GetNext()
	end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if sg:GetCount()>0 and (not nochk or Duel.SelectYesNo(tp,551)) then 
		local ssg=sg:Select(tp,1,63,nil)
		Duel.HintSelection(ssg)
		local sc=ssg:GetFirst()
		while sc do
			local e3=Effect.CreateEffect(c)
			e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CANNOT_TRIGGER)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			sc:RegisterEffect(e3)
			sc=ssg:GetNext()
		end
	end
end
function c244.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,800)
end