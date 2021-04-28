--眠
function c293.initial_effect(c)
	c:EnableReviveLimit()
	--over fusion summon
	local over=Effect.CreateEffect(c)
	over:SetType(EFFECT_TYPE_FIELD)
	over:SetCode(EFFECT_SPSUMMON_PROC)
	over:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	over:SetRange(LOCATION_HAND)
	over:SetCondition(c293.hspcon)
	over:SetOperation(c293.hspop)
	c:RegisterEffect(over)
	--Unaffected
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c293.efilter)
	c:RegisterEffect(e4)
	--Halve damage
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CHANGE_DAMAGE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,0)
	e5:SetValue(c293.val)
	c:RegisterEffect(e5)
	--Make itself be able to attack directly
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(293,0))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c293.condition2)
	e6:SetCost(c293.cost2)
	e6:SetOperation(c293.operation2)
	c:RegisterEffect(e6,false,REGISTER_FLAG_DETACH_XMAT)
	--destroy
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(46247282,1))
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetTarget(c293.destg)
	e7:SetOperation(c293.desop)
	c:RegisterEffect(e7)
	--disable field
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_DISABLE_FIELD)
	e8:SetProperty(EFFECT_FLAG_REPEAT)
	e8:SetOperation(c293.disop)
	c:RegisterEffect(e8)
	aux.GlobalCheck(c293,function()
		--Special summon procedure
		local e0=Effect.CreateEffect(c)
		e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetCode(EVENT_PHASE+PHASE_END)
		e0:SetCountLimit(1)
		e0:SetOperation(c293.endop)
		Duel.RegisterEffect(e0,0)
	end)
end
function c293.spfilter1(c)
	return c:IsFaceup() and c:IsLevelBelow(2) and c:IsSetCard(0x5f)
end
function c293.endop(e,tp,c)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c293.spfilter1,Duel.GetTurnPlayer(),LOCATION_MZONE,0,nil)
	local rc=g:GetFirst()
	while rc do
		if rc:GetFlagEffect(c293)==0 then
			local e1=Effect.CreateEffect(rc)
			e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE_START+PHASE_STANDBY)
			e1:SetCountLimit(1)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCondition(c293.ctcon)
			e1:SetLabel(0)
			e1:SetOperation(c293.ctop)
			rc:RegisterEffect(e1)
			rc:RegisterFlagEffect(c293,RESET_EVENT+RESETS_STANDARD,0,1)
		end
		rc=g:GetNext()
	end
end
function c293.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c293.ctop(e,tp,c)
	local c=e:GetHandler()
	if not c:IsControler(Duel.GetTurnPlayer()) then return end
	local ct=e:GetLabel()
	if c:GetFlagEffect(c293)~=0 and ct==2 then 
		c:RegisterFlagEffect(100000111,RESET_EVENT+RESETS_STANDARD,0,1)
	else
		e:SetLabel(ct+1)
	end
end
function c293.hspfilter(c,tp)
	return c:IsFaceup() and c:IsLevelBelow(2) and c:IsSetCard(0x5f) and c:GetFlagEffect(100000111)~=0
end
function c293.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(e:GetHandlerPlayer(),LOCATION_MZONE)+Duel.GetLocationCountFromEx(e:GetHandlerPlayer(),e:GetHandlerPlayer(),nil,c)>0
        and Duel.IsExistingMatchingCard(c293.hspfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c293.hspop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c293.hspfilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.Overlay(c,g)
    c:SetMaterial(g)
end
function c293.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c293.val(e,re,dam,r,rp,rc)
	return math.floor(dam/2)
end
function c293.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP() and not e:GetHandler():IsHasEffect(EFFECT_DIRECT_ATTACK)
end
function c293.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c293.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		--Attack directly this turn
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(3205)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c293.desfilter(c,g)
	return g:IsContains(c)
end
function c293.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local cg=e:GetHandler():GetColumnGroup()
	local g=Duel.GetMatchingGroup(c293.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,cg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c293.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local g=Duel.GetMatchingGroup(c293.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,cg)
		if g:GetCount()>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
function c293.disop(e,tp)
	local c=e:GetHandler()
	local zone = c:GetColumnZone(LOCATION_ONFIELD)
	local cg=c:GetColumnGroup()
	for tc in aux.Next(cg) do
		local dz = tc:IsLocation(LOCATION_MZONE) and 1 or (1 << 8)
		if tc:IsSequence(5,6) then
			dz1 = tc:IsControler(tp) and (dz << tc:GetSequence()) or (dz << (16 + tc:GetSequence()))
			dz2 = tc:IsControler(tp) and (dz << (16 + (11 - tc:GetSequence()))) or (dz << (11 - tc:GetSequence()))
			dz = dz1|dz2
		else
			dz = tc:IsControler(tp) and (dz << tc:GetSequence()) or (dz << (16 + tc:GetSequence()))
		end
		zone = zone &~dz
	end
	return zone
end
