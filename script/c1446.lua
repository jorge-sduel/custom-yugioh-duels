--Dark Pendulum Angel Knight
if not REVERSEPENDULUM_IMPORTED then Duel.LoadScript("proc_reverse_pendulum.lua") end
function c1446.initial_effect(c)
   RPendulum.AddProcedure(c)
c:AddSetcodesRule(1446,false,0xbb00)
	c:AddSetcodesRule(1446,false,0x601)
	--dark synchro summon	Synchro.AddDarkSynchroProcedure(c,Synchro.NonTuner(nil),nil,10)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(249000224,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCondition(c1446.condition)
	e2:SetTarget(c1446.target)
	e2:SetOperation(c1446.operation)
	c:RegisterEffect(e2)
	--p summon sucess
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetCondition(c1446.condition)
	e6:SetTarget(c1446.target)
	e6:SetOperation(c1446.operation)
	c:RegisterEffect(e6)
	--pendulum zone draw
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(16178681,1))
	e8:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_DRAW)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_PZONE)
	e8:SetTarget(c1446.drtg2)
	e8:SetOperation(c1446.drop2)
	c:RegisterEffect(e8)
end
function c1446.counterfilter(c)
	return not c:GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c1446.slfilter(c)
	return c:IsRace(RACE_WARRIOR)
end
function c1446.slcon(e)
	return not Duel.IsExistingMatchingCard(c1446.slfilter,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler())
end
function c1446.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(1446,tp,ACTIVITY_SPSUMMON) > 0
end
function c1446.retfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:GetPreviousLocation()==LOCATION_EXTRA
end
function c1446.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsController(tp)
	and c249000224.retfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c249000224.retfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c249000224.retfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c1446.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c1446.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c1446.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c1446.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		if Duel.Destroy(tc,REASON_EFFECT) and c:IsFaceup() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(1000)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_EXTRA_ATTACK)
			e2:SetValue(2)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)	
			--e2:SetCondition(c1446.atkcon)
			c:RegisterEffect(e2)
		end
	end
end
function c1446.atkcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_MZONE)>0
end
