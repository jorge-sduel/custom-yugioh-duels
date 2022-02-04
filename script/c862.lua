--Star-vader, Garnet Star "Legion"
function c862.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c862.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c862.spcon)
	e2:SetOperation(c862.spop)
	c:RegisterEffect(e2)
	--code
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_GRAVE)
	e3:SetValue(861)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_ADD_CODE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_ONFIELD+LOCATION_EXTRA+LOCATION_REMOVED+LOCATION_GRAVE)
	e4:SetValue(860)
	c:RegisterEffect(e4)
	--Lock
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(862,0))
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetTarget(c862.target)
	e5:SetOperation(c862.operation)
	c:RegisterEffect(e5)
	--atkup
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(862,1))
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_UPDATE_ATTACK)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c862.atcon)
	e6:SetValue(200)
	c:RegisterEffect(e6)
end
function c862.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c862.spfilter(c)
	return c:IsAbleToDeckAsCost()
end
function c862.spfilter1(c)
	return c:IsCode(861) and c:IsAbleToRemoveAsCost() and c:IsFaceup()
end
function c862.spfilter2(c)
	return c:IsCode(860) and c:IsAbleToRemoveAsCost()
end
function c862.spcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c862.spfilter,tp,LOCATION_GRAVE,0,4,nil)
		and Duel.IsExistingMatchingCard(c862.spfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(c862.spfilter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
end
function c862.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ct=Duel.SelectMatchingCard(tp,c862.spfilter2,tp,LOCATION_DECK,0,1,1,nil)
		if ct:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local rt=Duel.SelectMatchingCard(tp,c862.spfilter,tp,LOCATION_GRAVE,0,4,4,nil)
		Duel.SendtoDeck(rt,nil,4,REASON_COST)
		else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local rt1=Duel.SelectMatchingCard(tp,c862.spfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoDeck(rt1,nil,1,REASON_COST)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local rt2=Duel.SelectMatchingCard(tp,c862.spfilter,tp,LOCATION_GRAVE,0,3,3,nil)
		Duel.SendtoDeck(rt2,nil,3,REASON_COST)
		end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c862.spfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c862.spfilter2,tp,LOCATION_DECK,0,1,1,nil)
	g1:Merge(g2)	
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c862.atcon(e)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and e:GetHandler()==Duel.GetAttacker()
end
function c862.filter(c)
	return c:IsAbleToRemove()
end
function c862.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c862.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c862.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetChainLimit(aux.FALSE)
end
function c862.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectTarget(tp,c862.filter,tp,0,LOCATION_MZONE,1,1,nil)
	local tc1=g1:GetFirst()
	if tc1 then
		local seq=tc1:GetSequence()
		if tc1:IsLocation(LOCATION_MZONE) then seq=seq+16 end
		if tc1:IsLocation(LOCATION_SZONE) then seq=seq+24 end
		if tc1:IsRelateToEffect(e) then
		Duel.Remove(tc1,POS_FACEDOWN,REASON_EFFECT+REASON_TEMPORARY)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetLabel(seq)
		e1:SetLabelObject(tc1)
		e1:SetCondition(c862.discon)
		e1:SetOperation(c862.disop)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		e2:SetLabelObject(tc1)
		e2:SetCountLimit(1)
		e2:SetCondition(c862.recon)
		e2:SetOperation(c862.retop)
		Duel.RegisterEffect(e2,tp)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,c862.filter,tp,0,LOCATION_SZONE,1,1,nil)
	local tc2=g2:GetFirst()
	if tc2 then
		local seq=tc2:GetSequence()
		if tc2:IsLocation(LOCATION_MZONE) then seq=seq+16 end
		if tc2:IsLocation(LOCATION_SZONE) then seq=seq+24 end
		if tc2:IsRelateToEffect(e) then
		Duel.Remove(tc2,POS_FACEDOWN,REASON_EFFECT+REASON_TEMPORARY)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetLabel(seq)
		e1:SetLabelObject(tc2)
		e1:SetCondition(c862.discon)
		e1:SetOperation(c862.disop)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		e2:SetLabelObject(tc2)
		e2:SetCountLimit(1)
		e2:SetCondition(c862.recon)
		e2:SetOperation(c862.retop)
		Duel.RegisterEffect(e2,tp)	
		end
	end
end
function c862.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c862.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c862.discon(e,c)
	if e:GetLabelObject():IsLocation(LOCATION_REMOVED) then return true end
	return false
end
function c862.disop(e,tp)
	local dis1=bit.lshift(0x1,e:GetLabel())
	return dis1
end