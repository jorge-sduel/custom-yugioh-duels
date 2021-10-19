--odd eyes anthellion dragon
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,7,3)
	c:EnableReviveLimit()
	--over fusion summon
	local over=Effect.CreateEffect(c)
	over:SetType(EFFECT_TYPE_FIELD)
	over:SetCode(EFFECT_SPSUMMON_PROC)
	over:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	over:SetRange(LOCATION_EXTRA)
	over:SetCondition(s.hspcon)
	over:SetOperation(s.hspop)
	c:RegisterEffect(over)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16195942,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1,false,REGISTER_FLAG_DETACH_XMAT)
--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.con2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
	--pendulum
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(90036274,0))
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCondition(s.pencon)
	e7:SetTarget(s.pentg)
	e7:SetOperation(s.penop)
	c:RegisterEffect(e7)
end
s.pendulum_level=7
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	local ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_DAMAGE)
	if ex then return true end
	ex,cg,ct,cp,cv=Duel.GetOperationInfo(ev,CATEGORY_RECOVER)
	if not ex then return false end
	if cp~=PLAYER_ALL then return Duel.IsPlayerAffectedByEffect(cp,EFFECT_REVERSE_RECOVER)
	else return Duel.IsPlayerAffectedByEffect(0,EFFECT_REVERSE_RECOVER)
		or Duel.IsPlayerAffectedByEffect(1,EFFECT_REVERSE_RECOVER)
	end
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetLabel(cid)
	e1:SetValue(s.refcon)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
end
function s.refcon(e,re,val,r,rp,rc)
	local cc=Duel.GetCurrentChain()
	if cc==0 or (r&REASON_EFFECT)==0 then return end
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	if cid==e:GetLabel() then return 0
	else return val end
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,math.ceil(g:GetFirst():GetAttack()))
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=Duel.GetFieldGroup(tp,LOCATION_PZONE,0):GetSum(Card.GetAttack)
	local atk2=Duel.GetFieldGroup(tp,0,LOCATION_MZONE):GetSum(Card.GetAttack)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e3:SetValue(0)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e2:SetValue(atk2)
			c:RegisterEffect(e2)
	Duel.Damage(1-tp,atk,REASON_EFFECT)
end
function s.pencon(e,tp,eg,ep,ev,re,r,rp)
	return r&REASON_EFFECT+REASON_BATTLE~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function s.hspfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRankAbove(7)
end
function s.penfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsLevelAbove(7)
end
function s.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCountFromEx(e:GetHandlerPlayer(),e:GetHandlerPlayer(),nil,c)>0
        and Duel.IsExistingMatchingCard(s.hspfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
        and Duel.IsExistingMatchingCard(s.penfilter,e:GetHandlerPlayer(),LOCATION_HAND,0,1,nil)
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,s.hspfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local p=Duel.SelectMatchingCard(tp,s.penfilter,tp,LOCATION_HAND,0,1,1,nil)
		local mg1=g:GetFirst():GetOverlayGroup()
			Duel.Overlay(c,p)
			Duel.Overlay(c,mg1)
    Duel.Overlay(c,g)
    c:SetMaterial(g)
end
