--Star-vader, Dust Tail Unicorn
function c870.initial_effect(c)
	--Attach and Lock
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(870,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCost(c870.cost)
	e1:SetTarget(c870.target)
	e1:SetOperation(c870.operation)
	c:RegisterEffect(e1)
end
function c870.cfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x5DC) or c:IsSetCard(0x5AA)) and c:IsType(TYPE_XYZ)
end
function c870.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,870)==0 
	and Duel.IsExistingTarget(c870.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	g=Duel.SelectTarget(tp,c870.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	Duel.Overlay(tc,Group.FromCards(c))
	Duel.RegisterFlagEffect(tp,870,0,0,0)
end
function c870.filter(c)
	return c:IsAbleToRemove()
end
function c870.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c870.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c870.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c870.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetChainLimit(c870.limit(g:GetFirst()))
	e:SetLabelObject(g:GetFirst())
end
function c870.limit(c)
	return	function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function c870.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local seq=tc:GetSequence()
	if tc:IsLocation(LOCATION_MZONE) then seq=seq+16 end
	if tc:IsLocation(LOCATION_SZONE) then seq=seq+24 end
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT+REASON_TEMPORARY)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetLabel(seq)
		e1:SetLabelObject(tc)
		e1:SetCondition(c870.discon)
		e1:SetOperation(c870.disop)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		e2:SetLabelObject(tc)
		e2:SetCountLimit(1)
		e2:SetCondition(c870.recon)
		e2:SetOperation(c870.retop)
		Duel.RegisterEffect(e2,tp)	
	end
end
function c870.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c870.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c870.discon(e,c)
	if e:GetLabelObject():IsLocation(LOCATION_REMOVED) then return true end
	return false
end
function c870.disop(e,tp)
	local dis1=bit.lshift(0x1,e:GetLabel())
	return dis1
end