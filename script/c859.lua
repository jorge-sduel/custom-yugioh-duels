--Star-vader, "Omega" Glendios
function c859.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,10,3,c859.ovfilter,aux.Stringid(859,0),3,c859.xyzop)
	c:EnableReviveLimit()
	--cannot be destroyed
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--cannot be target effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c859.tgvalue)
	c:RegisterEffect(e2)
	--Power up "Reverse"
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(859,0))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c859.atktarget)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(400)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c859.atktarget)
	e4:SetValue(c859.tgvalue)
	c:RegisterEffect(e4)
	--Omega Lock
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(859,1))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCost(c859.cost)
	e5:SetTarget(c859.target)
	e5:SetOperation(c859.operation)
	c:RegisterEffect(e5)
	--World's End
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(859,2))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_CHAIN_END)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c859.wcon)
	e6:SetOperation(c859.wop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e7)
	local e8=e6:Clone()
	e8:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e8)
end
function c859.cvfilter(c)
	return c:IsSetCard(0x5DC) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c859.ovfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x5AA) or c:IsSetCard(0x5DC)) and (c:GetLevel()>=8 or c:GetRank()>=8)
		and Duel.IsExistingMatchingCard(c859.cvfilter,c:GetControler(),LOCATION_HAND,0,1,nil)
end
function c859.xyzop(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c859.cvfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c859.cvfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function c859.tgvalue(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c859.atktarget(e,c)
	return c:IsSetCard(0x5AA) and c:IsFaceup()
end
function c859.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) 
	and Duel.IsExistingMatchingCard(c859.cfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c859.cfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g:GetFirst(),REASON_COST)
end
function c859.cfilter(c)
	return c:IsSetCard(0x5AA) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c859.filter(c)
	return c:IsAbleToRemove()
end
function c859.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c859.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c859.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c859.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c859.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local seq=tc:GetSequence()
	if tc:IsLocation(LOCATION_MZONE) then seq=seq+16 end
	if tc:IsLocation(LOCATION_SZONE) then seq=seq+24 end
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetLabel(seq)
		e1:SetLabelObject(tc)
		e1:SetCondition(c859.discon)
		e1:SetOperation(c859.disop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c859.discon(e,c)
	if e:GetLabelObject():IsLocation(LOCATION_REMOVED) then return true end
	return false
end
function c859.disop(e,tp)
	local dis1=bit.lshift(0x1,e:GetLabel())
	return dis1
end
function c859.wcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer() and Duel.GetCurrentPhase()==PHASE_MAIN1
	and Duel.GetLP(e:GetHandlerPlayer())<4001 
	and Duel.IsExistingMatchingCard(c859.wfilter,c:GetControler(),0,LOCATION_REMOVED,5,nil)
end
function c859.wfilter(c)
	return c:IsFacedown()
end
function c859.wop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_OMEGA_GLENDIOS = 0x92
	Duel.Win(tp,0x92)
end
