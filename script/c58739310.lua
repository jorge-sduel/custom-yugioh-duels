--Chronospace Wizard
--Scripted by: XGlitchy30
--Time Leap by Swaggy
local cid,id=GetID()
cid.IsTimeleap=true
if not TIMELEAP_IMPORTED then Duel.LoadScript("proc_timeleap.lua") end
function cid.initial_effect(c)
	--time leap procedure
	Timeleap.AddProcedure(c,cid.tlfilter,1,1,cid.sumcon)
	--repeat effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(Timeleap.sumcon)
	e1:SetTarget(cid.tgtg)
	e1:SetOperation(cid.tgop)
	c:RegisterEffect(e1)
	--coin
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_COIN)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,id+100)
	e2:SetTarget(cid.rmtg)
	e2:SetOperation(cid.rmop)
	c:RegisterEffect(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,id+200)
	e3:SetCondition(cid.drcon)
	e3:SetTarget(cid.drtg)
	e3:SetOperation(cid.drop)
	c:RegisterEffect(e3)
end
cid.toss_coin=true
--time leap procedure
function cid.sumcon(e,c)
	return Duel.IsExistingMatchingCard(cid.sumconfilter,e:GetHandlerPlayer(),LOCATION_REMOVED,0,1,nil)
end
function cid.sumconfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_SPELLCASTER)
end
function cid.tlfilter(c)
	return c:IsType(TYPE_EFFECT)
end
--register coin toss
function cid.checkop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then
		for i=1,ev do
			Duel.RegisterFlagEffect(tp,id,0,0,1)
		end
	end
end
--repeat effect
function cid.filter(c)
	return c:IsType(TYPE_MONSTER)
end
function cid.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function cid.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,cid.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		tc:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
	end
end
function cid.resetcostcon(e,tp,eg,ep,ev,re,r,rp)
	local effect=e:GetLabelObject()
	local c=effect:GetHandler()
	return c:GetFlagEffect(id+100)<=0
end
--coin
function cid.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	if #g1>0 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD+LOCATION_HAND)
	end
	if #g2>0 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_ONFIELD)
	end
end
function cid.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COIN)
	local coin=Duel.AnnounceCoin(tp)
	local res=Duel.TossCoin(tp,1)
	local g,check=nil,0
	if coin~=res then
		check=1
		g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
	else
		g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	end
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,1,nil)
		sg:KeepAlive()
		if #sg<=0 then return end
		Duel.HintSelection(sg)
		if check==0 then
			Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
		else
			if Duel.Remove(sg,0,REASON_EFFECT+REASON_TEMPORARY)==0 then return end
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
			e1:SetCountLimit(1)
			e1:SetLabelObject(sg)
			e1:SetCondition(cid.retcon)
			e1:SetOperation(cid.retop)
			if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_DRAW then
				e1:SetLabel(0)
			else
				e1:SetLabel(Duel.GetTurnCount())
			end
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function cid.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetTurnCount()~=e:GetLabel()
end
function cid.retop(e,tp,eg,ep,ev,re,r,rp)
	local sg=e:GetLabelObject()
	if #sg==0 then
		e:Reset()
		return
	elseif #sg==1 then
		Duel.ReturnToField(sg:GetFirst())
	else
		for i=1,#sg do
			local tc=sg:Select(tp,1,1,nil)
			Duel.ReturnToField(tc:GetFirst())
		end
	end
	sg:DeleteGroup()
	e:Reset()
end
--draw
function cid.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_TIMELEAP)
end
function cid.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function cid.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_SKIP_DP)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_END,5)
		Duel.RegisterEffect(e1,tp)
	end
end
