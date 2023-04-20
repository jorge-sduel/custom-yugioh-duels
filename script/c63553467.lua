--Proxima Synchron
--Script by XGlitchy30
c63553467.IsEquilibrium=true
if not EQUILIBRIUM_IMPORTED then Duel.LoadScript("proc_equilibrium.lua") end
function c63553467.initial_effect(c)
	Equilibrium.AddProcedure(c)
	--tuner fix
	local tuner=Effect.CreateEffect(c)
	tuner:SetType(EFFECT_TYPE_SINGLE)
	tuner:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	tuner:SetCode(EFFECT_ADD_TYPE)
	tuner:SetCondition(c63553467.tunerfix)
	tuner:SetValue(TYPE_TUNER)
	c:RegisterEffect(tuner)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(63553467,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,63553467)
	e1:SetCost(c63553467.setcost)
	e1:SetTarget(c63553467.settg)
	e1:SetOperation(c63553467.setop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,63553417)
	e2:SetCondition(c63553467.spcon)
	e2:SetCost(c63553467.spcost)
	e2:SetTarget(c63553467.sptg)
	e2:SetOperation(c63553467.spop)
	c:RegisterEffect(e2)
	--[[quick activation
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(c63553467.synchrocon)
	e3:SetOperation(c63553467.synchroop)
	c:RegisterEffect(e3)]]
end
--filters
function c63553467.setfilter(c)
	return c:IsType(TYPE_PENDULUM) or c.IsEquilibrium
end
function c63553467.spcheck(c)
	return c.IsEquilibrium and c:IsFaceup()
end
--tuner fix
function c63553467.tunerfix(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsType(TYPE_MONSTER)
end
--set
function c63553467.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c63553467.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckPendulumZones(tp) and Duel.IsExistingMatchingCard(c63553470.actfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c63553467.setop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.CheckPendulumZones(tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c63553467.setfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
--	end
end
--special summon
function c63553467.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c63553467.spcheck,tp,LOCATION_MZONE,0,1,nil)
end
function c63553467.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoDeck(g,nil,0,REASON_COST)
end
function c63553467.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c63553467.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end
--quick_activate
