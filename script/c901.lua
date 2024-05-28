--
local s,id=GetID()
function s.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--Special summon procedure (from hand)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(143,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1)
	e3:SetTarget(s.valtg)
	e3:SetOperation(s.valop)
	c:RegisterEffect(e3)
	--attack res
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ATTACK)
	e4:SetRange(LOCATION_PZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetTarget(s.target1)
	c:RegisterEffect(e4)
	--atkup
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(99747800,0))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)	
	e6:SetCategory(CATEGORY_ATKCHANGE)
	e6:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetOperation(s.atkop)
	c:RegisterEffect(e6)
end
function s.target1(e,c)
	return c:IsStatus(STATUS_SPSUMMON_TURN) and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function s.IsScaleAbove(c,scale)
	return c:GetLeftScale()>=scale
end
function s.Count(c)
    if c:GetLeftScale()>=1 then return c:GetLeftScale()
    elseif c:GetRightScale()>=1 then return c:GetRightScale() end
    return 1
end
function s.spfilter(c)
	return c:IsMonster() and c:IsType(TYPE_PENDULUM)
end
function s.rescon(sg,e,tp,mg)
	if #sg>1 then
		return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:GetSum(Card.GetScale)>=13 and not sg:IsExists(s.IsScaleAbove,1,nil,13)
	else
		return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:GetSum(Card.GetScale)>=13
	end
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_PZONE+LOCATION_MZONE+LOCATION_SZONE,0,e:GetHandler())
	return aux.SelectUnselectGroup(rg,e,tp,1,99,s.rescon,0)
end
function s.breakcon(sg,e,tp,mg)
	return sg:GetSum(Card.GetScale)>=13
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_PZONE+LOCATION_SZONE+LOCATION_MZONE,0,e:GetHandler())
	local mg=aux.SelectUnselectGroup(rg,e,tp,1,99,s.rescon,1,tp,HINTMSG_TOGRAVE,s.breakcon,s.breakcon,true)
	if #mg>0 then
		mg:KeepAlive()
		e:SetLabelObject(mg)
		return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,#g,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
	end
	local ct=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)-ct*500)
end
function s.copfilter(c)
	return c:IsFaceup() and c:IsStatus(STATUS_DISABLED)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e1:SetValue(1000)
	c:RegisterEffect(e1)
end
function s.sfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function s.valtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
local at=Duel.GetAttacker()
	if chkc then return false end
	if chk==0 then return  Duel.IsExistingTarget(s.sfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	e:SetLabelObject(at)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	Duel.SelectTarget(tp,s.sfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function s.valop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local o=Duel.GetAttacker()
	local s=g:GetFirst()
	if s==o then s=g:GetNext() end
	if s:IsFaceup() and o:IsFaceup() and s:IsRelateToEffect(e) and o:IsRelateToBattle() then
		local val=s:GetAttack()*-1
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(val)
		o:RegisterEffect(e1) 
	end
		local tg=s:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
	local op=s:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	Duel.Release(s,REASON_COST)
end
