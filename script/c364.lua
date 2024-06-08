--odd eyes rise dragon
local s,id=GetID()
function s.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_PZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--xyz
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(511000189)
	e2:SetValue(7)
	e2:SetRange(LOCATION_PZONE)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCondition(s.con)
	e3:SetCode(511001225)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(32086564,0))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_BATTLED)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(s.atkcon)
	e6:SetOperation(s.atkop)
	c:RegisterEffect(e6)
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return a:IsControler(tp) and a:IsOnField() and d and d:IsDefensePos()
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_MZONE)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetAttacker()
	if tc and tc:IsFaceup() and tc:IsRelateToBattle() then
		local maxv=0
		local eff={tc:GetCardEffect(EFFECT_EXTRA_ATTACK)}
		for _,te in ipairs(eff) do
			local val=te:GetValue()
			if type(val)=='function' then
				maxv=math.max(val(te,tc),maxv)
			else
				maxv=math.max(val,maxv)
			end
		end
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EXTRA_ATTACK)
		e2:SetValue(maxv+1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
		tc:RegisterEffect(e2)
	end
end
function s.tg(e,c)
	return c:IsType(TYPE_MONSTER)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function s.costfilter(c)
	return c:IsType(TYPE_XYZ) and (c:GetAttack()>0 or c:GetDefense()>0)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroupCost(tp,s.costfilter,1,false,nil,nil)
	end
	local sc=Duel.SelectReleaseGroupCost(tp,s.costfilter,1,1,false,nil,nil):GetFirst()
	local atk=sc:GetAttack()
	local def=sc:GetDefense()
	Duel.Release(sc,REASON_COST)
	local op=nil
	local b1=atk>0
	local b2=def>0
	if b1 and b2 then
		op=Duel.SelectEffect(tp,
			{b1,aux.Stringid(80161395,1)},
			{b2,aux.Stringid(80161395,2)})
	else
		op=b1 and 1 or 2
	end
	local val=op==1 and atk or def
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(val)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,val)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end

