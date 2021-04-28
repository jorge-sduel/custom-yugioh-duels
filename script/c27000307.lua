--CCG: Elemental Conflux
function c27000307.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e1:SetType(EFFECT_TYPE_ACTIVATE)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetCountLimit(1,27000307+EFFECT_COUNT_CODE_OATH)
		e1:SetTarget(c27000307.target)
		e1:SetOperation(c27000307.activate)
	c:RegisterEffect(e1)
	--Extra Normal Summon
	local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetRange(LOCATION_FZONE)
		e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
		e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
		e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xbf))
	c:RegisterEffect(e2)
	--local e3=e2:Clone()
	--	e3:SetCode(EFFECT_EXTRA_SET_COUNT)
	--c:RegisterEffect(e3)
	--Change Attribute
	local e4=Effect.CreateEffect(c)
		e4:SetDescription(aux.Stringid(27000307,0))
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_QUICK_O)
		e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e4:SetRange(LOCATION_FZONE)
		e4:SetCode(EVENT_SUMMON_SUCCESS)
		e4:SetCondition(c27000307.ATTCon1)
		e4:SetTarget(c27000307.ATTTarg)
		e4:SetOperation(c27000307.ATTOpe)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
		e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
		e6:SetCode(EVENT_FLIP)
	c:RegisterEffect(e6)	
	--Charmer Buff
	local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_FIELD)
		e7:SetCode(27000307)
		e7:SetCode(EVENT_ADJUST)
		e7:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e7:SetRange(LOCATION_FZONE)
		e7:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e7:SetTarget(c27000307.BUFFTarg)
	c:RegisterEffect(e7)
	if not c27000307.global_check then
		c27000307.global_check=true
		local cb=Effect.CreateEffect(c)
		cb:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		cb:SetCode(EVENT_ADJUST)
		cb:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		cb:SetOperation(c27000307.BUFFOpe)
		Duel.RegisterEffect(cb,0)
	end
end
--{Activate: Search}
function c27000307.filter(c)
	return c:IsSetCard(0xbf) 
		and c:IsType(TYPE_MONSTER) 
		and c:IsAbleToHand()
end
function c27000307.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if e:GetHandler():IsType(TYPE_MONSTER) then return end
	if chk==0 then return Duel.IsExistingMatchingCard(c27000307.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c27000307.cfilter(c)
	return c:IsSetCard(0x14d)
	   and c:IsAbleToHand()
end
function c27000307.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,c27000307.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g1:GetCount()>0 then
		if Duel.SendtoHand(g1,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,g1)
			if not Duel.IsExistingMatchingCard(c27000307.cfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then return end
			if Duel.SelectYesNo(tp,aux.Stringid(27000307,1)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local g2=Duel.SelectMatchingCard(tp,c27000307.cfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
				if g2:GetCount()>0 then
					Duel.SendtoHand(g2,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,g2)
				end
			end	
		end
	end
end
--{Trigger: Change Attribute}
function c27000307.SUMFilter1(c,tp)
	return c:IsFaceup() 
		and c:IsSetCard(0xbf)
		--and c:IsControler(tp) 
end
function c27000307.ATTCon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c27000307.SUMFilter1,1,nil,tp)
		and eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_EXTRA)
end
function c27000307.ATTCon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c27000307.SUMFilter1,1,nil,tp)
end
function c27000307.ATTFilter(c)
	return c:IsFaceup()
end
function c27000307.ATTTarg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.SelectTarget(tp,c27000307.ATTFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local rc=Duel.AnnounceAttribute(tp,1,0xffff)
	e:SetLabel(rc)
end
function c27000307.ATTOpe(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local rc=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(e:GetLabel())
		tc:RegisterEffect(e1)
	end
end
--{Field: Charmer Buff}
function c27000307.BUFFTarg(e,c)
	return c:IsType(TYPE_FLIP)
		and c:IsSetCard(0xbf)
end
function c27000307.BUFFFilter(c)
	return c:IsType(TYPE_FLIP)
		and c:IsSetCard(0xbf)
end
function c27000307.BUFFChk(c)
	return c:IsCode(27000307) 
		and c:IsFaceup()
end
function c27000307.BUFFOpe(e,tp,eg,ep,ev,re,r,rp)
	--if not Duel.IsExistingMatchingCard(c27000307.BUFFChk,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then return end
	local g=Duel.GetMatchingGroup(c27000307.BUFFFilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	while tc do
		if  tc:GetFlagEffect(27000307)==0 then
			tc:ReplaceEffect(27000307,0,0,1)  		-- " exploit: Remove all of the Charmer's previous effect
			--Control (with Elemental Conflux)
			local r1=Effect.CreateEffect(tc)
				r1:SetDescription(aux.Stringid(tc:GetOriginalCode(),0))
				r1:SetCategory(CATEGORY_CONTROL)
				r1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
				r1:SetProperty(EFFECT_FLAG_CARD_TARGET)
				r1:SetCode(EVENT_FLIP)
				r1:SetCountLimit(1)
				r1:SetCondition(c27000307.CTRCon1)
				r1:SetTarget(c27000307.CTRTarg1)
				r1:SetOperation(c27000307.CTROpe)
				--r1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(r1,true)
			--Control (w/o Elemental Conflux)
			local r2=Effect.CreateEffect(tc)
				r2:SetDescription(aux.Stringid(tc:GetOriginalCode(),0))
				r2:SetCategory(CATEGORY_CONTROL)
				r2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP)
				r2:SetProperty(EFFECT_FLAG_CARD_TARGET)
				r2:SetCountLimit(1)
				r2:SetCondition(c27000307.CTRCon2)
				r2:SetTarget(c27000307.CTRTarg2)
				r2:SetOperation(c27000307.CTROpe)
				--r2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(r2,true)
			--Set
			local r3=Effect.CreateEffect(tc)
				r3:SetDescription(aux.Stringid(40659562,0))
				r3:SetCategory(CATEGORY_POSITION)
				r3:SetType(EFFECT_TYPE_IGNITION)
				r3:SetRange(LOCATION_MZONE)
				r3:SetCountLimit(1)
				r3:SetCondition(c27000307.CTRCon1)
				r3:SetTarget(c27000307.SETTarg)
				r3:SetOperation(c27000307.SETOpe)
				--r3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(r3,true)
			tc:RegisterFlagEffect(27000307,0,0,1)
		end
		tc=g:GetNext()
	end
end
-- {Monster Buff: Control}
function c27000307.CTRCon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c27000307.BUFFChk,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c27000307.CTRFilter1(c)
	return c:IsFaceup() 
		and c:IsControlerCanBeChanged() 
end
function c27000307.CTRTarg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c27000307.CTRFilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c27000307.CTRFilter1,tp,0,LOCATION_MZONE,1,nil) end
	if not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g=Duel.SelectTarget(tp,c27000307.CTRFilter1,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
	end
end
function c27000307.CTRCon2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c27000307.BUFFChk,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		return true
	end
end
function c27000307.CTRFilter2(c,attrib)
	return c:IsFaceup() 
		and c:IsAttribute(attrib)
		and c:IsControlerCanBeChanged() 
end
function c27000307.CTRTarg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local attrib=e:GetOwner():GetOriginalAttribute()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c27000307.CTRFilter2(chkc,attrib) end
	if chk==0 then return Duel.IsExistingTarget(c27000307.CTRFilter2,tp,0,LOCATION_MZONE,1,nil,attrib) end
	if not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g=Duel.SelectTarget(tp,c27000307.CTRFilter2,tp,0,LOCATION_MZONE,1,1,nil,attrib)
		Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
	end
end
function c27000307.CTROpe(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local attrib=e:GetHandler():GetOriginalAttribute()	
	if not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then
		if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsAttribute(attrib) then
			c:SetCardTarget(tc)
			local c1=Effect.CreateEffect(c)
				c1:SetType(EFFECT_TYPE_SINGLE)
				c1:SetCode(EFFECT_SET_CONTROL)
				c1:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
				c1:SetRange(LOCATION_MZONE)
				c1:SetValue(tp)
				c1:SetLabel(0)
				c1:SetReset(RESET_EVENT+0x1fc0000)
				c1:SetCondition(c27000307.CTRCon)
			tc:RegisterEffect(c1)
		end
	end
end
function c27000307.CTRCon(e)
	local c=e:GetOwner()
	local h=e:GetHandler()
	local attrib=e:GetOwner():GetOriginalAttribute()
	return h:IsAttribute(attrib) 
		and c:IsHasCardTarget(h)
end
-- {Monster Buff: Set}
function c27000307.SETTarg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanTurnSet() end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
end
function c27000307.SETOpe(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
	end
end