--Rose Violet Dragon
function c234.initial_effect(c)
	--synchro summon
		Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c234.destg)
	e2:SetValue(c234.value)
	e2:SetOperation(c234.desop)
	c:RegisterEffect(e2)	
--effect damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetOperation(c234.activate2)
	c:RegisterEffect(e3)
end
c234[0]=0
c234[1]=0
function c234.dfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsRace(RACE_PLANT) or c:IsRace(RACE_DRAGON)
end
function c234.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local count=eg:FilterCount(c234.dfilter,nil)
		e:SetLabel(count)
		return count>0 and Duel.IsCanRemoveCounter(tp,1,1,0x1041,count,REASON_COST)
	end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c234.value(e,c)
	return c:IsFaceup() and c:GetLocation()==LOCATION_MZONE and c:IsRace(RACE_PLANT) or c:IsRace(RACE_DRAGON)
end
function c234.desop(e,tp,eg,ep,ev,re,r,rp)
	local count=e:GetLabel()
	Duel.RemoveCounter(tp,1,1,0x1041,count,REASON_COST)
end
function c234.activate2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,234)~=0 then return end
	c234[tp]=0
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(c234.dval)
	e1:SetReset(RESET_PHASE+PHASE_END,1)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,218,RESET_PHASE+PHASE_END,0,1)
end
function c234.dval(e,re,dam,r,rp,rc)
	if c234[e:GetOwnerPlayer()]==1 or bit.band(r,REASON_EFFECT)~=0 then
		return math.floor(0)
	else return dam end
end
