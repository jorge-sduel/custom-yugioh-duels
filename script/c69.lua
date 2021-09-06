--Supremacy Synchro
function c69.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c69.target)
	c:RegisterEffect(e1)
	--disable attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(78625592,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c69.tg)
	e2:SetOperation(c69.op)
	c:RegisterEffect(e2)
	--Return
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(51,2))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_HAND)

	e4:SetOperation(c69.rop)
	c:RegisterEffect(e4)
	--place
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(47408488,1))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCode(EFFECT_SPSUMMON_PROC_G)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetRange(LOCATION_PZONE)
e5:SetCountLimit(1,10000000)
	e5:SetTarget(c69.target3)
	e5:SetOperation(c69.activate3)
	e5:SetValue(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e5)
	--indes
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_ADD_RACE)
	e6:SetValue(RACE_DRAGON)
	c:RegisterEffect(e6)
	--indes
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_TYPE_SINGLE)

	e7:SetCode(EFFECT_SET_BASE_ATTACK)
	e7:SetValue(1800)
	c:RegisterEffect(e7)
	--indes
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_TYPE_SINGLE)

	e8:SetCode(EFFECT_SET_BASE_DEFENSE)
	e8:SetValue(1600)
	c:RegisterEffect(e8)
	--indes
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_TYPE_SINGLE)

	e9:SetCode(EFFECT_ADD_ATTRIBUTE)
	e9:SetValue(ATTRIBUTE_WIND)
	c:RegisterEffect(e9)
	--indes
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_TYPE_SINGLE)

	e11:SetCode(EFFECT_CHANGE_LEVEL)
	e11:SetValue(2)
	c:RegisterEffect(e11)
end
c68.pendulum_level=2
function c69.ffilter(c,tp)
	return
 (c:IsType(TYPE_TRAP) and c:IsType(TYPE_PENDULUM))
end
function c69.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local a=Duel.GetAttacker()
	if Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE) and c69.tg(e,tp,Group.FromCards(a),ep,ev,re,r,rp,0) 
		and Duel.SelectYesNo(tp,aux.Stringid(61965407,1)) then
		e:SetOperation(c69.op)
		c69.tg(e,tp,Group.FromCards(a),ep,ev,re,r,rp,1)
	else
		e:SetOperation(nil)
	end
end
function c69.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.GetAttacker():IsType(TYPE_SYNCHRO) end
end
function c69.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.NegateAttack()
end
function c69.rop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEDOWN,true)

end
function c69.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_PZONE,0,2,nil) end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	Duel.SetTargetCard(g)
end
function c69.activate3(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if not tc1 or not tc2 or not tc1:IsRelateToEffect(e) or not tc2:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(1163)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_BOTH_SIDE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c69.plcon)
	e1:SetTarget(c69.pltg)
	e1:SetOperation(c69.plop)
	e1:SetValue(SUMMON_TYPE_PENDULUM)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc1:RegisterEffect(e1)
	tc1:RegisterFlagEffect(69,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,tc2:GetFieldID())
	tc2:RegisterFlagEffect(69,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,tc1:GetFieldID())
end
function c69.plcon(e,c,og)
	if c==nil then return true end
	local tp=e:GetOwnerPlayer()
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if rpz==nil or rpz:GetFieldID()~=c:GetFlagEffectLabel(68) or Duel.GetFlagEffect(tp,10000000)>0 then return false end
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCountFromEx(tp)
	if ft<=0 then return false end
	if og then
		return og:IsExists(c69.ffilter,1,nil,e,tp,lscale,rscale)
	else
		return Duel.IsExistingMatchingCard(c69.ffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,lscale,rscale)
	end
end
function c69.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c69.ffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
end
function c69.plop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c69.ffilter,tp,LOCATION_EXTRA,0,1,ft,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_MONSTER)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
		Duel.RaiseEvent(g,EVENT_CUSTOM+47408488,e,0,tp,0,0)
	end
end
function c69.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c69.ffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
end
function c69.plop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c69.ffilter,tp,LOCATION_EXTRA,0,1,ft,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_MONSTER)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
		Duel.RaiseEvent(g,EVENT_CUSTOM+47408488,e,0,tp,0,0)
	end
end
