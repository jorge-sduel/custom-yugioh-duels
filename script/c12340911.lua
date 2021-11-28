--Asura Reunion
function c12340911.initial_effect(c)
		c:EnableReviveLimit()
	--fusion material	
Fusion.AddProcMixN(c,true,true,aux.FilterBoolFunctionEx(Card.IsAttackAbove,2000,2)
	--remove fusion type
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(0xee)
	e0:SetCode(EFFECT_REMOVE_TYPE)
	e0:SetValue(TYPE_FUSION)
	c:RegisterEffect(e0)
	--gain attributes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c12340911.matcheck)
	c:RegisterEffect(e1)
    --immune
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340111,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c12340911.immcost)
	e2:SetOperation(c12340911.immop)
	c:RegisterEffect(e2)
	--battle
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(c12340911.con)
	e3:SetValue(c12340911.val)
	c:RegisterEffect(e3)
	--draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12340911,1))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCondition(c12340911.spcon)
	e4:SetTarget(c12340911.sptg)
	e4:SetOperation(c12340911.spop)
	c:RegisterEffect(e4)
end
function c12340911.matcheck(e,c)
	local g=c:GetMaterial()
	for i=0,10 do
		local t = math.pow(2, i)
		if g:IsExists(Card.IsAttribute,1,nil,t) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_ATTRIBUTE)
			e1:SetValue(t)
			e1:SetReset(RESET_EVENT+0xff0000)
			c:RegisterEffect(e1)
		end
	end
end

function c12340911.immcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil)
	local ct=0
	if g:GetFirst():IsType(TYPE_MONSTER) then ct=TYPE_MONSTER
	elseif g:GetFirst():IsType(TYPE_SPELL) then ct=TYPE_SPELL
	elseif g:GetFirst():IsType(TYPE_TRAP) then ct=TYPE_TRAP end
	e:SetLabel(ct)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c12340911.immop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(c12340911.immfilter)
	e1:SetLabel(e:GetLabel())
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1,true)
end
function c12340911.immfilter(c,te)
	return te:IsActiveType(e:GetLabel())
end

function c12340911.con(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and Duel.GetAttackTarget()~=nil
		and (Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler())
end
function c12340911.val(e,c)
	local g=Duel.GetMatchingGroup(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	return -g:GetClassCount(Card.GetAttribute)*300
end

function c12340911.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetReasonPlayer()~=tp and c:IsReason(REASON_EFFECT) and c:IsPreviousPosition(POS_FACEUP)
		and c:GetPreviousControler()==c:GetOwner()
end
function c12340911.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local attr=e:GetHandler():GetPreviousAttributeOnField()
	if chk==0 and attr==0 then return false end
	local ct=0
	for i=0,10 do
		local t = math.pow(2, i)
		if bit.band(t,attr)==t then ct=ct+1 end
	end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,ct) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c12340911.spop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
