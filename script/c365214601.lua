--Sin Red Demons Dragon
function c365214601.initial_effect(c)
	c:EnableReviveLimit()
	--Special Summon by Sending 1 "Red Dragon Archfiend" to the Graveyard
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c365214601.sinsumcon)
	e1:SetOperation(c365214601.sinsumop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(aux.FALSE)
	c:RegisterEffect(e2)
	--Absolute Power Force
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(365214601,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLED)
	e3:SetCondition(c365214601.powerforcecon)
	e3:SetTarget(c365214601.powerforcetg)
	e3:SetOperation(c365214601.powerforceop)
	c:RegisterEffect(e3)
	--Demon Meteor
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(365214601,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCondition(c365214601.demonmeteorcon)
	e4:SetTarget(c365214601.demonmeteortg)
	e4:SetOperation(c365214601.demonmeteorop)
	c:RegisterEffect(e4)
	--No Demon Meteor
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetCondition(c365214601.nodemonmeteorcon)
	e5:SetTarget(c365214601.nodemonmeteortg)
	e5:SetOperation(c365214601.nodemonmeteorop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
	--If "Malefic World" is not Face-Up on the Field, Destroy this Card
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_SELF_DESTROY)
	e7:SetCondition(c365214601.selfdestroycon)
	c:RegisterEffect(e7)
	if not c365214601.global_check then
		c365214601.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(c365214601.check)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ATTACK_DISABLED)
		ge2:SetOperation(c365214601.check2)
		Duel.RegisterEffect(ge2,0)
	end
end
function c365214601.sinsumfilter(c)
	return c:IsCode(70902743) and c:IsAbleToGraveAsCost()
end
function c365214601.sinsumcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c365214601.sinsumfilter,c:GetControler(),LOCATION_EXTRA,0,1,nil)
end
function c365214601.sinsumop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=Duel.GetFirstMatchingCard(c365214601.sinsumfilter,tp,LOCATION_EXTRA,0,nil)
	Duel.SendtoGrave(tc,REASON_COST)
end
function c365214601.check(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local ct=tc:GetFlagEffectLabel(365214601)
	if ct then
		tc:SetFlagEffectLabel(365214601,ct+1)
	else
		tc:RegisterFlagEffect(365214601,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1,1)
	end
end
function c365214601.check2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local ct=tc:GetFlagEffectLabel(365214601)
	if ct then
		tc:SetFlagEffectLabel(365214601,ct-1)
	end
end
function c365214601.powerforcecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget() and not Duel.GetAttackTarget():IsAttackPos()
end
function c365214601.powerforcefilter(c)
	return not c:IsAttackPos() and c:IsDestructable()
end
function c365214601.powerforcetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c365214601.powerforcefilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c365214601.powerforceop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c365214601.powerforcefilter,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function c365214601.demonmeteorfilter(c)
	local ph=Duel.GetCurrentPhase()
	local ct=c:GetFlagEffectLabel(365214601)
	return (not ct or ct==0) and c:IsDestructable() and (ph==PHASE_MAIN2 or ph==PHASE_END) and c:GetSummonType()==SUMMON_TYPE_SPECIAL
end
function c365214601.demonmeteorcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c365214601.demonmeteortg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c365214601.demonmeteorfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c365214601.demonmeteorop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c365214601.demonmeteorfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	Duel.Destroy(g,REASON_EFFECT)
end
function c365214601.nodemonmeteorcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==tp and (ph==PHASE_MAIN2 or ph==PHASE_END) and not c:IsStatus(STATUS_DISABLED)
end
function c365214601.nodemonmeteortg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetCard(eg)
	Duel.SetChainLimit(aux.FALSE)
end
function c365214601.nodemonmeteorfilter(c,e,tp)
	return c:IsControler(tp) and c:IsFaceup()
end
function c365214601.nodemonmeteorop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c365214601.nodemonmeteorfilter,nil,tp)
	local dg=Group.CreateGroup()
	local c=e:GetHandler()
	local tc=g:GetFirst()
	if tc:IsFaceup() then
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(c365214601.immunefilter)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	end
end
function c365214601.immunefilter(e,te)
	return te:GetHandler():IsCode(365214601)
end
function c365214601.selfdestroycon(e)
	return not Duel.IsEnvironment(27564031)
end