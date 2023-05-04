--created by Walrus, coded by Lyris
local cid,id=GetID()
cid.IsEquilibrium=true
if not EQUILIBRIUM_IMPORTED then Duel.LoadScript("proc_equilibrium.lua") end
function cid.initial_effect(c)
	--
	Equilibrium.AddProcedure(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(97268402,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cid.con)
	e1:SetOperation(Equilibrium.desop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(cid.splimit)
	c:RegisterEffect(e2)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_PZONE)
	e6:SetCountLimit(1)
	e6:SetCategory(CATEGORY_RECOVER+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e6:SetCost(cid.cost)
	e6:SetTarget(cid.target)
	e6:SetOperation(cid.operation)
	c:RegisterEffect(e6)
	--aux.CannotBeEDMaterial(c,nil,LOCATION_MZONE)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	c:RegisterEffect(e4)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cid.drcon1)
	e1:SetOperation(cid.drop1)
	e1:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cid.regcon)
	e2:SetOperation(cid.regop)
	e1:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetCondition(cid.drcon2)
	e3:SetOperation(cid.drop2)
	e1:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e3)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_REMOVE)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCategory(CATEGORY_TOEXTRA)
	e5:SetTarget(cid.tg)
	e5:SetOperation(cid.op)
	c:RegisterEffect(e5)
end
function cid.con(e)
	local tp=e:GetHandler():GetControler()
	local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if not tc1 or not tc2 then return false end
	return tc1:GetLevel()==tc2:GetLevel()
end
function cid.cfilter(c)
	return c:IsType(TYPE_PENDULUM)
end
function cid.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xc97) then return false end
	return bit.band(sumtype,SUMMON_TYPE_EQUILIBRIUM)==SUMMON_TYPE_EQUILIBRIUM
end
function cid.filter(c,sp)
	return c:GetSummonPlayer()==sp and c:GetSummonLocation()==LOCATION_EXTRA
end
function cid.drcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cid.filter,1,nil,1-tp)
		and (not re:IsHasType(EFFECT_TYPE_ACTIONS) or re:IsHasType(EFFECT_TYPE_CONTINUOUS))
end
function cid.drop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(300)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
end
function cid.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cid.filter,1,nil,1-tp)
		and re:IsHasType(EFFECT_TYPE_ACTIONS) and not re:IsHasType(EFFECT_TYPE_CONTINUOUS)
end
function cid.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id,RESET_CHAIN,0,1)
end
function cid.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)>0
end
function cid.drop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local n=Duel.GetFlagEffect(tp,id)
	Duel.ResetFlagEffect(tp,id)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(300*n)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,1,nil) and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	e:SetLabelObject(tc)
	Duel.Remove(tc,POS_FACEUP,REASON_COST) and e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetParam(500)
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function cid.thfilter(c)
	return c:IsCode(id-6,id-16,id-17) and c:IsAbleToHand()
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.Recover(p,d,REASON_EFFECT)<1
		or not (e:GetLabelObject():IsSetCard(0x4c97) or e:GetLabelObject():IsSetCard(0x6c97)) then return end
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cid.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
	if #g>0 and Duel.SelectYesNo(tp,1109) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g:Select(tp,1,1,nil)
		Duel.BreakEffect()
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function cid.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsForbidden() end
end
function cid.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsForbidden() then return end
	local b1=Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
	if b1 and Duel.SelectOption(tp,1160,1105)==0 then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	else
		Duel.SelectOption(tp,1105)
		Duel.SendtoExtraP(c,nil,REASON_EFFECT)
	end
end
