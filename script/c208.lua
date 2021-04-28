--fus pen
function c208.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMixRep(c,true,true,c208.ffilter,2,99)
--pendulum summon
	Pendulum.AddProcedure(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)
	c:RegisterEffect(e2)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c208.matcheck)
	c:RegisterEffect(e3)
		--pendulum
local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c208.descon)
	e4:SetOperation(c208.regop)
	c:RegisterEffect(e4)
	--send replace
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(94,2))
	e5:SetCode(EFFECT_SEND_REPLACE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c208.repcondition)
	e5:SetTarget(c208.reptarget)
	e5:SetOperation(c208.repoperation)
	c:RegisterEffect(e5)
	--reduce
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CHANGE_DAMAGE)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetRange(LOCATION_PZONE)
	e6:SetTargetRange(1,0)
	e6:SetCondition(c208.damcon)
	e6:SetValue(c208.damval)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e7)
end
function c208.ffilter(c,fc)
	return c:IsType(TYPE_MONSTER)
end
function c208.matcheck(e,c)
	local ct=c:GetMaterial():GetClassCount(Card.GetCode)
	if ct>0 then
		local ae=Effect.CreateEffect(c)
		ae:SetType(EFFECT_TYPE_SINGLE)
		ae:SetCode(EFFECT_SET_BASE_ATTACK)
		ae:SetValue(ct*1000)
		ae:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(ae)
		local be=Effect.CreateEffect(c)
		be:SetType(EFFECT_TYPE_SINGLE)
		be:SetCode(EFFECT_SET_BASE_DEFENSE)
		be:SetValue(ct*1000)
		be:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(be)
	end
	if ct>=2 then
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(208,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c208.remlimit)
	c:RegisterEffect(e1)
	local e2 = e1:Clone()
	e2:SetCode(EFFECT_CANNOT_TO_DECK)
	c:RegisterEffect(e2)
	local e3 = e1:Clone()
	e3:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(e3)
	local e4 = e1:Clone()
	e4:SetCode(EFFECT_CANNOT_TO_GRAVE)
	c:RegisterEffect(e4)
	end
	if ct>=3 then
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(208,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	end
	if ct>=4 then
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(208,2))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	end
	if ct>=5 then
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(208,3))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	end
	if ct>=6 then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_SZONE)
	e1:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e1)
	end
end
function c208.remlimit(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c208.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_PENDULUM and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c208.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(2000)
		e1:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(e1)
local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(2800)
		e2:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(e2)
end
function c208.repcondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)<2
end
function c208.reptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetDestination()==LOCATION_GRAVE end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<0 then return false end
	return Duel.SelectEffectYesNo(tp,c)
end
function c208.repoperation(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	Duel.RaiseEvent(c,47408488,e,0,tp,0,0)
end
function c208.cfilter(c)
	return c:IsFaceup()
end
function c208.damcon(e)
	return Duel.IsExistingMatchingCard(c208.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,2,nil)
end
function c208.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0 end
	return val
end