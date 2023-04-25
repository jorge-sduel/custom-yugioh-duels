--Pandemoniumgraph Berserker 
local cid,id=GetID()
cid.IsEquilibrium=true
if not EQUILIBRIUM_IMPORTED then Duel.LoadScript("proc_equilibrium.lua") end
function cid.initial_effect(c)
	Equilibrium.AddProcedure(c)
--destroy
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(97268402,0))
	e0:SetCategory(CATEGORY_DESTROY)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_HAND)
	e0:SetTarget(cid.destarget)
	e0:SetOperation(Equilibrium.desop1)
	c:RegisterEffect(e0)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCondition(cid.condition)
	e1:SetCost(cid.cost)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.operation)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,id)
	e2:SetTarget(cid.settg)
	e2:SetOperation(cid.setop)
	c:RegisterEffect(e2)
end
function cid.destarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and cid.desfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(cid.filter,tp,LOCATION_PZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cid.desfilter,tp,LOCATION_PZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cid.setfilter(c)
	return c:IsSetCard(0xcf80) and c.IsEquilibrium and not c:IsCode(id)
end
function cid.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckPendulumZones(tp)
		and Duel.IsExistingMatchingCard(cid.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cid.setop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.CheckPendulumZones(tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cid.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function cid.filter(c,tp)
	return c:IsControler(tp) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsSetCard(0xcf80)
end
function cid.condition(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(cid.filter,1,nil,tp)
		and Duel.IsChainNegatable(ev)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	--if e:GetHandler():IsRelateToEffect(e) then
	--	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	--end
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	--if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.NegateActivation(ev) then
		if re:IsHasType(EFFECT_TYPE_ACTIVATE) then
			Duel.SendtoGrave(eg,REASON_EFFECT)
		end
		Duel.BreakEffect()
		--Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
