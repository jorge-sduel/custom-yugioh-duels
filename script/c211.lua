--シンクロ・マテリアル
function c211.initial_effect(c)
	c:SetUniqueOnField(1,0,211)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(c211.atkcon)
	e1:SetOperation(c211.act_op)
	c:RegisterEffect(e1)
--add link type
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(TYPE_MONSTER+TYPE_LINK)
	c:RegisterEffect(e2)
	--act qp in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(c211.con)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c211.destg)
	e4:SetOperation(c211.desop)
	c:RegisterEffect(e4)
end
function c211.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:GetSequence()<5
end
function c211.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c211.cfilter,tp,LOCATION_MZONE,0,1,nil,seq)
end
function c211.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c211.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c211.filter(c,seq,flag)
	return c:GetSequence()<5 and (c:GetSequence()==seq or c:GetSequence()==seq+1 or c:GetSequence()==seq-1)
end
function c211.atkcon(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c211.filter,tp,LOCATION_MZONE,0,1,nil,e:GetHandler():GetSequence(),flag) end
end
function c211.filter2(c,seq,flag)
	return c:GetSequence()<5 and (c:GetSequence()==seq or c:GetSequence()==seq+1 or c:GetSequence()==seq-1)
end
function c211.act_op(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c211.filter2,tp,LOCATION_MZONE,0,nil,e:GetHandler():GetSequence(),e:GetHandler():GetFlagEffect(211))
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(tc:GetAttack())
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
	sg:KeepAlive()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetLabel(fid)
	e2:SetLabelObject(sg)
	e2:SetCondition(c211.descon)
	Duel.RegisterEffect(e2,tp)
end
function c211.dfilter(c)
	return c:IsDestructable() and c:GetSequence()<5
end
function c211.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c211.dfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c211.dfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c211.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c211.dfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
