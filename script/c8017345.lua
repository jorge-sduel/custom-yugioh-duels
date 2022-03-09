--Zextratum, Il Drago Abissomonium
local cid,id=GetID()
cid.IsEquilibrium=true
function cid.initial_effect(c)
	Equilibrium.AddProcedure(c)
	c:EnableReviveLimit()
	--nukel
	local p1=Effect.CreateEffect(c)
	p1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	p1:SetType(EFFECT_TYPE_IGNITION)
	p1:SetRange(LOCATION_HAND)
	p1:SetCountLimit(1,id)
	p1:SetCost(cid.actcost)
	p1:SetTarget(cid.acttg)
	p1:SetOperation(cid.actop)
	c:RegisterEffect(p1)
	--immunity
	local p2=Effect.CreateEffect(c)
	p2:SetType(EFFECT_TYPE_FIELD)
	p2:SetCode(EFFECT_IMMUNE_EFFECT)
	p2:SetRange(LOCATION_PZONE)
	p2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	p2:SetTarget(function(e,c) return c:IsSummonType(SUMMON_TYPE_EQUILIBRIUM) and c:IsStatus(STATUS_SPSUMMON_TURN) end)
	p2:SetValue(function(e,te) return te:GetOwnerPlayer()~=e:GetHandlerPlayer() end)
	c:RegisterEffect(p2)
	--End the Battle Phase
	local p2=Effect.CreateEffect(c)
	p2:SetDescription(aux.Stringid(id,0))
	p2:SetType(EFFECT_TYPE_QUICK_O)
	p2:SetRange(LOCATION_PZONE)
	p2:SetCode(EVENT_FREE_CHAIN)
	p2:SetCondition(cid.bpcon)
	p2:SetCost(cid.bpcost)
	p2:SetOperation(cid.bpop)
	c:RegisterEffect(p2)
	--MONSTER EFFECTS
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cid.atkval)
	c:RegisterEffect(e1)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(cid.atktg)
	e2:SetValue(cid.atkval2)
	c:RegisterEffect(e2)
	--leave replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(cid.reptg)
	e3:SetValue(cid.repval)
	e3:SetOperation(cid.repop)
	c:RegisterEffect(e3)
	--End the Battle Phase
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id)
	e4:SetCost(cid.bpcost)
	e4:SetOperation(cid.bpop2)
	c:RegisterEffect(e4)
	--attach 1 "D/D/D"
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,2))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(cid.xyzcon)
	e5:SetTarget(cid.xyztg)
	e5:SetOperation(cid.xyzop)
	c:RegisterEffect(e5)
end
function cid.bpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsBattlePhase() and Duel.GetCurrentPhase()<PHASE_BATTLE
end
function cid.bpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cid.bpop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
end
function cid.bpop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)/2)
end
function cid.bpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLp(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
end
function cid.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
--NUKE
function cid.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cid.prevfilter(c,tp)
	return c:GetPreviousControler()==tp
end
-----------
function cid.actcon(e,tp,eg,ep,ev,re,r,rp)
	return e:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cid.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(cid.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	local ct=math.min(2,#g)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function cid.actop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cid.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #g>0 then
		if Duel.Destroy(g,REASON_EFFECT)==0 then return end
		local ct=Duel.GetOperatedGroup():FilterCount(cid.prevfilter,nil,tp)
		if ct>0 then
			Duel.BreakEffect()
Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	Duel.Overlay(c,g)			Duel.Draw(tp,ct,REASON_EFFECT)
			Duel.Draw(1-tp,ct,REASON_EFFECT)
		end
	end
end
--ATK UP
function cid.atkfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c.IsEquilibrium
end
function cid.eqfilter(c)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_PZONE) or c:IsFaceup()) and c.IsEquilibrium
end
---------
function cid.atkval(e,c)
	return Duel.GetMatchingGroupCount(cid.eqfilter,e:GetHandlerPlayer(),LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_PZONE,0,nil)*800
end
--ATK DOWN
function cid.atktg(e,c)
	return c~=e:GetHandler()
end
function cid.atkval2(e,c)
	return Duel.GetMatchingGroupCount(cid.eqfilter,e:GetHandlerPlayer(),LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_PZONE,0,nil)*-800
end
--LEAVE REPLACE
--filters
function cid.repfilter(c,e)
	return c:IsLocation(LOCATION_ONFIELD) and not c:IsReason(REASON_REPLACE)
		and bit.band(c:GetDestination(),LOCATION_MZONE)==0 and bit.band(c:GetDestination(),LOCATION_SZONE)==0
		and bit.band(c:GetDestination(),LOCATION_FZONE)==0 and bit.band(c:GetDestination(),LOCATION_PZONE)==0
end
function cid.rmfilter(c)
	return c:IsAbleToRemove() and c.IsEquilibrium and c:IsType(TYPE_MONSTER) and not c:IsStatus(STATUS_LEAVE_CONFIRMED)
end
---------
function cid.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return r&REASON_EFFECT~=0 and re and rp~=tp and cid.repfilter(e:GetHandler(),e)
		and Duel.IsExistingMatchingCard(cid.rmfilter,tp,LOCATION_DECK,0,2,nil) 
	end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		return true
	end
	return false
end
function cid.repval(e,c)
	return cid.repfilter(c,e)
end
function cid.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
	local g=Duel.SelectMatchingCard(tp,cid.rmfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end
function cid.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function cid.xyzfilter(c)
	return c:IsFaceup() and c.IsEquilibrium 
end
function cid.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) end
end
function cid.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(cid.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local og=g:Select(tp,1,1,nil)
		Duel.Overlay(c,og)
	end
end
