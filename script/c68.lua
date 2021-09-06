--Dragon Tail Swords
function c68.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_ATTACK)
	e1:SetTarget(c68.target)
	e1:SetOperation(c68.operation)
	c:RegisterEffect(e1)
	--disable attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(68,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c68.condition)
	e2:SetCost(c68.cost)
	e2:SetOperation(c68.operation)
	c:RegisterEffect(e2)
	--cannot direct attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(68,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_ATTACK)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCondition(c68.grcondition)
	e3:SetCost(aux.bfgcost)
	e3:SetOperation(c68.groperation)
	c:RegisterEffect(e3)
	--Return
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(51,2))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_HAND)
	e4:SetOperation(c68.rop)
	c:RegisterEffect(e4)
	--indes
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_TYPE_SINGLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_ADD_RACE)
	e6:SetValue(RACE_DRAGON)
	c:RegisterEffect(e6)
	--indes
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_TYPE_SINGLE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_SET_BASE_ATTACK)
	e7:SetValue(1900)
	c:RegisterEffect(e7)
	--indes
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_TYPE_SINGLE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_SET_BASE_DEFENSE)
	e8:SetValue(1900)
	c:RegisterEffect(e8)
	--indes
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_TYPE_SINGLE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EFFECT_ADD_ATTRIBUTE)
	e9:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e9)
	--place
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(47408488,1))
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetCode(EFFECT_SPSUMMON_PROC_G)
	e10:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e10:SetRange(LOCATION_PZONE)
e10:SetCountLimit(1,10000000)
	e10:SetTarget(c68.target3)
	e10:SetOperation(c68.activate3)
	e10:SetValue(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e10)
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(1163)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetCode(EFFECT_SPSUMMON_PROC_G)
	e11:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_BOTH_SIDE)
	e11:SetRange(LOCATION_PZONE)
e11:SetCountLimit(1,10000000)
	e11:SetCondition(c68.plcon)
	e11:SetTarget(c68.pltg)
	e11:SetOperation(c68.plop)
	e11:SetValue(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e11)
end
c68.pendulum_level=4
function c68.ffilter(c,tp)
	return
 c:IsType(TYPE_PENDULUM) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup())
end
function c68.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c68.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
	e:SetLabel(1)
end
function c68.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(0)
	if Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE) and tp~=Duel.GetTurnPlayer()
		and Duel.CheckLPCost(tp,500) and Duel.SelectYesNo(tp,94) then
		Duel.PayLPCost(tp,500)
		e:SetLabel(1)
		e:GetHandler():RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,65)
	end
end
function c68.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.NegateAttack()
end
function c68.grcondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and (Duel.IsAbleToEnterBP() or (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE))
end
function c68.groperation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c68.rop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEDOWN,true)

end
function c68.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_PZONE,0,2,nil) end
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	Duel.SetTargetCard(g)
end
function c68.activate3(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if not tc1 or not tc2 or not tc1:IsRelateToEffect(e) or not tc2:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(1163)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_BOTH_SIDE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c68.plcon)
	e1:SetTarget(c68.pltg)
	e1:SetOperation(c68.plop)
	e1:SetValue(SUMMON_TYPE_PENDULUM)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc1:RegisterEffect(e1)
	tc1:RegisterFlagEffect(68,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,tc2:GetFieldID())
	tc2:RegisterFlagEffect(68,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,tc1:GetFieldID())
end
function c68.plcon(e,c,og)
	if c==nil then return true end
	local tp=e:GetOwnerPlayer()
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCountFromEx(tp)
	if ft<=0 then return false end
	if og then
		return og:IsExists(c68.ffilter,1,nil,e,tp,lscale,rscale)
	else
		return Duel.IsExistingMatchingCard(c68.ffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,lscale,rscale)
	end
end
function c68.pltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c68.ffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
end
function c68.plop(e,tp,eg,ep,ev,re,r,rp,c,sg,inchain)
	local tp=e:GetOwnerPlayer()
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
	local tg=Duel.SelectMatchingCard(tp,c68.ffilter,tp,LOCATION_EXTRA,0,Duel.IsSummonCancelable() and 0 or 1,ft,nil,e,tp,lscale,rscale)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	ft=math.min(ft,aux.CheckSummonGate(tp) or ft)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=tg:Select(tp,1,ft,nil)
	local c=e:GetHandler()
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		Duel.SpecialSummonStep(tc,SUMMON_TYPE_PENDULUM,tp,tp,true,true,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_ADD_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_MONSTER)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetCode(EFFECT_REMOVE_TYPE)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e2:SetValue(TYPE_TRAP)
			tc:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
	if lp>0 then
		Duel.BreakEffect()
	end
end
