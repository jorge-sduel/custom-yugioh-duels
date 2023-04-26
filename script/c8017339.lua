--Portale Ciondolo
--Scripted by: XGlitchy30
local cid,id=GetID()
cid.IsEquilibrium=true
if not EQUILIBRIUM_IMPORTED then Duel.LoadScript("proc_equilibrium.lua") end
function cid.initial_effect(c)
	Equilibrium.AddProcedure(c)
	--scale
	local p0=Effect.CreateEffect(c)
	p0:SetType(EFFECT_TYPE_SINGLE)
	p0:SetCode(EFFECT_CHANGE_RSCALE)
	p0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	p0:SetRange(LOCATION_PZONE)
	p0:SetCondition(cid.sccon)
	p0:SetValue(5)
	c:RegisterEffect(p0)
--extra pande location
	--tohand
	local p1=Effect.CreateEffect(c)
	p1:SetDescription(aux.Stringid(id,0))
	p1:SetCategory(CATEGORY_TOHAND)
	p1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	p1:SetCode(EVENT_SPSUMMON_SUCCESS)
	p1:SetRange(LOCATION_PZONE)
	p1:SetCondition(cid.spcon1)
	p1:SetCountLimit(1)
	p1:SetTarget(cid.sptg1)
	p1:SetOperation(cid.spop1)
	c:RegisterEffect(p1)
	--MONSTER EFFECTS
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCost(cid.spcost)
	e1:SetTarget(cid.sptg)
	e1:SetOperation(cid.spop)
	c:RegisterEffect(e1)
	local e1x=e1:Clone()
	e1x:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1x)
--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(97268402,0))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_HAND)
	e5:SetTarget(cid.destarget)
	e5:SetOperation(Equilibrium.desop1)
	c:RegisterEffect(e5)
--Activate
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_BATTLE_DESTROYED)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCost(cid.cost)
	e6:SetTarget(cid.target)
	e6:SetOperation(cid.activate)
	c:RegisterEffect(e6)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,cid.counterfilter)
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return Duel.GetLocationCount(tc:GetPreviousControler(),LOCATION_MZONE)>0 and #eg==1 end
	Duel.SetTargetCard(tc)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.MoveToField(tc,tc:GetPreviousControler(),tc:GetPreviousControler(),LOCATION_MZONE,tc:GetPreviousPosition(),true)
		tc:SetStatus(STATUS_SPSUMMON_STEP,false)
		tc:SetStatus(STATUS_SPSUMMON_TURN,true)
	end
end
--GENERIC FILTERS
function cid.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA)
end
function cid.destarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and cid.desfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(cid.filter,tp,LOCATION_PZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cid.desfilter,tp,LOCATION_PZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
--SCALE
function cid.sccon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_HAND,0)>0
end
function cid.excfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_PENDULUM)
end
--EXTRA PANDE LOCATION
function cid.extracon(e)
	local tp=e:GetHandlerPlayer()
	local g=Duel.GetFieldGroup(tp,LOCATION_EXTRA+LOCATION_GRAVE,0)
	return aux.PandActCheck(e) and not Duel.IsExistingMatchingCard(cid.doubtfilter,tp,LOCATION_MZONE,0,1,nil)
		and #g>0 and not g:IsExists(cid.excfilter,1,nil) and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)<=1
end
function cid.extraval(mode,c,e,tp,lscale,rscale,eset,tg)
	if not mode then return false end
	if mode==0 then
		return LOCATION_DECK
	elseif mode==1 then
		return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_PANDEMONIUM)
	elseif mode==2 then
		return {[LOCATION_DECK]=1}
	elseif mode==3 then
		return false
	elseif mode==4 then
		return function (c) return c:IsLocation(LOCATION_EXTRA) end
	end
end
function cid.doubtfilter(c)
	return c:IsFacedown() or c:IsType(TYPE_MONSTER)
end
function cid.limfilter(c)
	return c:GetPreviousLocation()==LOCATION_DECK
end
-------------
--SPSUMMON
function cid.spfilter(c,e,sp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,sp,true,false)
end
-------------
function cid.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)<=1 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
--cid.conditionsum)
	e1:SetCondition(cid.conditionsum)
--function (e,tp) return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)>=1 end)
	e1:SetTarget(cid.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cid.conditionsum(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SUMMON)==1 and Duel.GetActivityCount(tp,ACTIVITY_FLIPSUMMON)==0
		and Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==1 end
end
function cid.splimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA)
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	local gct=Duel.GetMatchingGroupCount(cid.spfilter,tp,LOCATION_PZONE,0,nil,e,tp)
	if ct>gct then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,gct,tp,LOCATION_PZONE)
	else
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,tp,LOCATION_PZONE)
	end
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	local g=Duel.GetMatchingGroup(cid.spfilter,tp,LOCATION_PZONE,0,nil,e,tp)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,ct,ct,nil)
	local tc=sg:GetFirst()
	while tc do
		if tc:IsType(TYPE_PENDULUM) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		else
			tc:AddMonsterAttribute(TYPE_PENDULUM)
			Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		end
		tc=sg:GetNext()
	end
end
function cid.cfilter1(c,tp)
	return c:IsSummonPlayer(tp) and c:IsSummonType(SUMMON_TYPE_EQUILIBRIUM)
end
function cid.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return e:GetHandlerPlayer() and tc:IsSummonType(SUMMON_TYPE_EQUILIBRIUM) and tc.IsEquilibrium
end
function cid.filter1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c.IsEquilibrium and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cid.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cid.filter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cid.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cid.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
