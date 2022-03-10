--Pandemoniumplaza
--Scripted by: XGlitchy30
local cid,id=GetID()
function cid.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cid.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(cid.desreptg)
	e2:SetValue(cid.desrepval)
	e2:SetOperation(cid.desrepop)
	c:RegisterEffect(e2)
	--set
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,id+100)
	e3:SetTarget(cid.settg)
	e3:SetOperation(cid.setop)
	c:RegisterEffect(e3)
end
--ACTIVATE
function cid.filter(c,sg)
	if not c.IsEquilibrium or not c:IsType(TYPE_MONSTER) or not c:IsAbleToHand() or #sg<=0 then return false end
	local lscale,rscale,ct,check=c:GetLeftScale(),c:GetRightScale(),0,false
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local tc=sg:GetFirst()
	while tc do
		local lv=tc:GetLevel()
		if lv>lscale and lv<rscale then
			ct=ct+1
		end
		tc=sg:GetNext()
	end
	if ct==#sg then check=true end
	return check
end
function cid.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetLevel()>0
end
----------
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local field=Duel.GetMatchingGroup(cid.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local g=Duel.GetMatchingGroup(cid.filter,tp,LOCATION_DECK,0,nil,field)
	if Duel.GetFlagEffect(tp,id)<=0 and g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		local field2=Duel.GetMatchingGroup(cid.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=Duel.SelectMatchingCard(tp,cid.filter,tp,LOCATION_DECK,0,1,1,nil,field2):GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
		Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	end
end
--DESTROY REPLACE
function cid.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_PZONE)
		and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function cid.dryfilter(c,e)
	return c.IsEquilibrium and c:IsType(TYPE_MONSTER)
		and c:IsDestructable(e) and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
---------
function cid.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(cid.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(cid.dryfilter,tp,LOCATION_DECK,0,1,nil,e)
	end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local sg=Duel.SelectMatchingCard(tp,cid.dryfilter,tp,LOCATION_DECK,0,1,1,nil,e)
		e:SetLabelObject(sg:GetFirst())
		sg:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function cid.desrepval(e,c)
	return cid.repfilter(c,e:GetHandlerPlayer())
end
function cid.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,1-tp,id)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end
--SET
function cid.setfilter(c,e,tp)
	return c.IsEquilibrium
end
------------
function cid.filter2(c)
	return c:IsFacedown() and c:GetSequence()<5
end
function cid.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cid.filter2,tp,LOCATION_SZONE,LOCATION_SZONE,1,e:GetHandler()) end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
	Duel.SelectTarget(tp,cid.filter2,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,e:GetHandler())
end
function cid.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFaceup() then
		if c:IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
			c:CancelToGrave()
			Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
		end
		return
	end
	if tc:IsType(TYPE_TRAP) or tc:IsType(TYPE_SPELL) then
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local condition
		local cost
		local target
		local operation
		if te then
			condition=te:GetCondition()
			cost=te:GetCost()
			target=te:GetTarget()
			operation=te:GetOperation()
		end
		local chk=te and te:GetCode()==EVENT_FREE_CHAIN and te:IsActivatable(tep)
			and (not condition or condition(te,tep,eg,ep,ev,re,r,rp))
			and (not cost or cost(te,tep,eg,ep,ev,re,r,rp,0))
			and (not target or target(te,tep,eg,ep,ev,re,r,rp,0))
		Duel.ChangePosition(tc,POS_FACEUP)
		Duel.ConfirmCards(tp,tc)
		if chk then
			Duel.ClearTargetCard()
			e:SetProperty(te:GetProperty())
			Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
			if tc:GetType()==TYPE_TRAP then
				tc:CancelToGrave(false)
			end
			tc:CreateEffectRelation(te)
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			if target~=te:GetTarget() then
				target=te:GetTarget()
			end
			if target then target(te,tep,eg,ep,ev,re,r,rp,1) end
			local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
			for tg in aux.Next(g) do
				tg:CreateEffectRelation(te)
			end
			tc:SetStatus(STATUS_ACTIVATED,true)
			if tc:IsHasEffect(EFFECT_REMAIN_FIELD) then
				tc:SetStatus(STATUS_LEAVE_CONFIRMED,false)
			end
			if operation~=te:GetOperation() then
				operation=te:GetOperation()
			end
			if operation then operation(te,tep,eg,ep,ev,re,r,rp) end
			tc:ReleaseEffectRelation(te)
			for tg in aux.Next(g) do
				tg:ReleaseEffectRelation(te)
			end
		else
			if Duel.Destroy(tc,REASON_EFFECT)==0 then
				Duel.SendtoGrave(tc,REASON_RULE)
			end
		end
	else
		Duel.ConfirmCards(tp,tc)
	end
	if c:IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		c:CancelToGrave()
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end
