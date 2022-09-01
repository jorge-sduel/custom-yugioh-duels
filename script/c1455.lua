--Dark Pendulum Angel Knight
if not REVERSEPENDULUM_IMPORTED then Duel.LoadScript("proc_reverse_pendulum.lua") end
function c1455.initial_effect(c)
   RPendulum.AddProcedure(c)
c:AddSetcodesRule(1455,false,0xbb00)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE)

	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)

	c:RegisterEffect(e2)
	--Disable effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1455,0))
	e3:SetCategory(CATEGORY_DISABLE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c1455.distg)
	e3:SetOperation(c1455.disop)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1455,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c1455.target)
	e4:SetOperation(c1455.operation)
	c:RegisterEffect(e4)
--Special Summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SPSUMMON_PROC)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCondition(c1455.spcon)
	e5:SetTarget(c1455.sptg)
	e5:SetOperation(c1455.spop)
	c:RegisterEffect(e5)
	--If your cyberse monster battles, negate all other card effects on the field, also use original ATK/DEF
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(1455,2))
	e6:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e6:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c1455.condition)
	e6:SetOperation(c1455.operation2)
	c:RegisterEffect(e6)
	--direct attack
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e7)
	--spsummon condition
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetCode(EFFECT_SPSUMMON_CONDITION)
	e8:SetValue(c1455.splimit)
	c:RegisterEffect(e8)
end
function c1455.dmfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c1455.spcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),Card.IsType,5,false,5,true,c,c:GetControler(),nil,false,nil,TYPE_MONSTER)
end
function c1455.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,Card.IsType,5,5,false,true,true,c,nil,nil,false,nil,TYPE_MONSTER)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
	return true
	end
	return false
end
function c1455.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end
function c1455.splimit(e,se,sp,st)
	local sc=se:GetHandler()
	return sc:IsType(TYPE_PENDULUM)
end
function c1455.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and aux.disfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(aux.disfilter1,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,aux.disfilter1,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c1455.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c1455.filter(c)
	return c:IsFaceup() or c:IsFacedown()
end
function c1455.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1455.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c1455.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c1455.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c1455.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function c1455.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	if not at then return false end
	if a:IsControler(1-tp) then a,at=at,a end
	return a:IsFaceup() and a:IsCode(1455)
end
function c1455.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetTarget(c1455.distg2)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c1455.disop2)
	e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e3,tp)
	if a:IsRelateToBattle() then
		local aa=a:GetTextAttack()
		local ad=a:GetTextDefense()
		if a:IsImmuneToEffect(e) then
			aa=a:GetBaseAttack()
			ad=a:GetBaseDefense() end
		if aa<0 then aa=0 end
		if ad<0 then ad=0 end
	end
	if d and d:IsRelateToBattle() then
		local da=d:GetTextAttack()
		local dd=d:GetTextDefense()
		if d:IsImmuneToEffect(e) then 
			da=d:GetBaseAttack()
			dd=d:GetBaseDefense() end
		if da<0 then da=0 end
		if dd<0 then dd=0 end
	end
end
function c1455.distg2(e,c)
	return c~=e:GetOwner()
end
function c1455.disop2(e,tp,eg,ep,ev,re,r,rp)
	local loc,ce=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_EFFECT)
	if loc&LOCATION_ONFIELD==LOCATION_ONFIELD and ce:GetOwner()~=e:GetOwner() then
		Duel.NegateEffect(ev)
	end
end