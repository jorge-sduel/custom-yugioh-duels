--escorpion
function c207.initial_effect(c)
	--xyz summon
		Xyz.AddProcedure(c,nil,6,2)
	c:EnableReviveLimit()
--pendulum summon
	Pendulum.AddProcedure(c)
	--confirm
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(207,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c207.target)
	e1:SetOperation(c207.operation)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(81336148,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetCondition(c207.spcon)
	e2:SetTarget(c207.sptg)
	e2:SetOperation(c207.spop)
	c:RegisterEffect(e2)
	--send replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(94,2))
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c207.repcondition)
	e3:SetTarget(c207.reptarget)
	e3:SetOperation(c207.repoperation)
	c:RegisterEffect(e3)
	--limit break
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(810,0))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetHintTiming(0,TIMING_STANDBY_PHASE+0x1c0)
	e4:SetCost(c207.cost)
	e4:SetOperation(c207.foperation)
	e4:SetCountLimit(1)
	c:RegisterEffect(e4,false,REGISTER_FLAG_DETACH_XMAT)
end
c207.pendulum_level=6
function c207.repcondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)<2
end
function c207.reptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetDestination()==LOCATION_GRAVE end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<0 then return false end
	return Duel.SelectEffectYesNo(tp,c)
end
function c207.repoperation(e,tp,eg,ep,ev,re,r,rp,chk)
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
function c207.filter(c)
	return not c:IsPublic()
end
function c207.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(c207.filter,tp,LOCATION_HAND,0,nil)*Duel.GetMatchingGroupCount(c207.filter,tp,0,LOCATION_HAND,nil)>0 end
end
function c207.operation(e,tp,eg,ep,ev,re,r,rp)
	local hg1=Duel.GetMatchingGroup(c207.filter,tp,LOCATION_HAND,0,nil)
	local hg2=Duel.GetMatchingGroup(c207.filter,tp,0,LOCATION_HAND,nil)
	if #hg1==0 or #hg2==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc1=hg1:Select(tp,1,1,nil):GetFirst()
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
	local tc2=hg2:Select(1-tp,1,1,nil):GetFirst()
	local tg=Group.FromCards(tc1,tc2)
	Duel.ConfirmCards(tp,tg)
	if tc1:IsType(TYPE_MONSTER) and tc2:IsType(TYPE_MONSTER) then
		local i=0
		local p=tp
		while i<=1 do
			local tc=tg:Filter(Card.IsControler,nil,p):GetFirst()
			if Duel.GetLocationCount(p,LOCATION_MZONE)>0
				and tc:IsCanBeSpecialSummoned(e,0,p,false,false)
				and Duel.SelectYesNo(p,aux.Stringid(89928517,1)) then
				Duel.SpecialSummonStep(tc,0,p,p,false,false,POS_FACEUP)
			end
			i=i+1
			p=1-tp
		end
		Duel.SpecialSummonComplete()
	elseif tc1:IsType(TYPE_SPELL) and tc2:IsType(TYPE_SPELL) then
		Duel.Draw(tp,2,REASON_EFFECT)
		Duel.Draw(1-tp,2,REASON_EFFECT)
	elseif tc1:IsType(TYPE_TRAP) and tc2:IsType(TYPE_TRAP)
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_DECK,0,2,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_DECK,2,nil) then
		for p=0,1 do
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(p,Card.IsAbleToGrave,p,LOCATION_DECK,0,2,2,nil)
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
	Duel.ShuffleHand(tp)
	Duel.ShuffleHand(1-tp)
end
function c207.spcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return d and Duel.GetTurnPlayer()==tp and a:IsRace(RACE_WARRIOR) and (d:IsRelateToBattle() or not d:IsReason(REASON_BATTLE))
end
function c207.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c207.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c207.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c207.ftarget(e,c)
	return c:IsType(TYPE_MONSTER)
end
function c207.foperation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local tp=c:GetControler()
	if tp then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
	    e2:SetType(EFFECT_TYPE_FIELD)
	    e2:SetCode(EFFECT_INDESTRUCTABLE)
		e2:SetRange(LOCATION_MZONE)
	    e2:SetTargetRange(LOCATION_MZONE,0)
	    e2:SetTarget(c207.ftarget)
	    e2:SetValue(1)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	    c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetRange(LOCATION_MZONE)
		e3:SetTargetRange(LOCATION_MZONE,0)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e3:SetTarget(c207.ftarget)
		e3:SetValue(500)
		c:RegisterEffect(e3)
	end
end