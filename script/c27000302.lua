---CCG: Familiar-Possessed Blizzard Charmer - Eria
function c27000302.initial_effect(c)
	c:SetSPSummonOnce(27000302)
	Pendulum.AddProcedure(c,false)
	--pendulum summon limit
	local p1=Effect.CreateEffect(c)
		p1:SetType(EFFECT_TYPE_FIELD)
		p1:SetRange(LOCATION_PZONE)
		p1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		p1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
		p1:SetTargetRange(1,0)
		p1:SetTarget(c27000302.PENDLimit)
	c:RegisterEffect(p1)
	--Activate
	local p2=Effect.CreateEffect(c)
		p2:SetDescription(1160)
		p2:SetType(EFFECT_TYPE_ACTIVATE)
		p2:SetCode(EVENT_FREE_CHAIN)
		p2:SetTarget(c27000302.SCTarg)
		p2:SetOperation(c27000302.SCOpe)
	c:RegisterEffect(p2)
	--special summon condition
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_SPSUMMON_CONDITION)
		e1:SetValue(c27000302.SPLimit)
	c:RegisterEffect(e1)
	--special summon proc
	local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(27000302,3))
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_SPSUMMON_PROC)
		e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e2:SetRange(LOCATION_EXTRA)
		e2:SetCondition(c27000302.SPCon)
		e2:SetOperation(c27000302.SPOpe)
		e2:SetValue(SUMMON_TYPE_RITUAL)
	c:RegisterEffect(e2)
	--control
	local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(27000302,0))
		e3:SetCategory(CATEGORY_CONTROL)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e3:SetCode(EVENT_SPSUMMON_SUCCESS)
		e3:SetTarget(c27000302.CTRTarg)
		e3:SetOperation(c27000302.CTROpe)
	c:RegisterEffect(e3)
	--add to hand
	local e4=Effect.CreateEffect(c)
		e4:SetDescription(aux.Stringid(27000302,2))
		e4:SetCategory(CATEGORY_TOHAND)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
		e4:SetCode(EVENT_DESTROYED)
		e4:SetCondition(c27000302.THCon)
		e4:SetTarget(c27000302.THTarg)
		e4:SetOperation(c27000302.THOpe)
	c:RegisterEffect(e4)
	--limit spell card
	local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e5:SetCode(EVENT_CHAINING)
		e5:SetRange(LOCATION_MZONE)
		e5:SetOperation(c27000302.aclimit1)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e6:SetCode(EVENT_CHAIN_NEGATED)
		e6:SetRange(LOCATION_MZONE)
		e6:SetOperation(c27000302.aclimit2)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_FIELD)
		e7:SetCode(EFFECT_CANNOT_ACTIVATE)
		e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e7:SetRange(LOCATION_MZONE)
		e7:SetTargetRange(0,1)
		e7:SetCondition(c27000302.econ)
		e7:SetValue(c27000302.elimit)
	c:RegisterEffect(e7)
end
 -- {Pendulum Summon Limit: Charmers & Familiar-Possessed}
 function c27000302.PENDLimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsSetCard(0xbf) or c:IsSetCard(0xc0) then return false end
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
-- {Pendulum Search: Elemental Conflux}
function c27000302.SCFilter(c)
	return c:IsCode(27000307) 
		and c:IsAbleToHand()
end
function c27000302.SCChk(c)
	return c:IsCode(27000307) 
		and c:IsFaceup()
end
function c27000302.SCTarg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return true
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c27000302.SCOpe(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if -- not Duel.GetCustomActivityCount(27000302,tp,ACTIVITY_SPSUMMON)==0 or
	   not Duel.IsExistingMatchingCard(c27000302.SCChk,tp,LOCATION_ONFIELD,0,1,nil) then 
		if  Duel.IsExistingMatchingCard(c27000302.SCFilter,tp,LOCATION_DECK,0,1,nil) 
		and Duel.SelectYesNo(tp,aux.Stringid(27000302,2)) then
			if not c:IsRelateToEffect(e) then return end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g1=Duel.SelectMatchingCard(tp,c27000302.SCFilter,tp,LOCATION_DECK,0,1,1,nil)
			if g1:GetCount()>0 then
				Duel.SendtoHand(g1,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g1)
				Duel.BreakEffect()
				Duel.Destroy(c,REASON_EFFECT)
				local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
					e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
					e1:SetTargetRange(1,0)
					e1:SetTarget(c27000302.SCLimit)
					e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end
function c27000302.SCLimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsSetCard(0xbf) or c:IsSetCard(0xc0))
end
-- {Special Summon Limit: Only from hand and Extra Deck}
function c27000302.SPLimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL
end
-- {Special Summon Proc: Familiar-Possessed}
function c27000302.SPfilter1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xbf) and c:IsReleasable()
		and Duel.IsExistingMatchingCard(c27000302.SPfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c27000302.SPfilter2(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and c:IsReleasable()
end
function c27000302.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) 
		and sg:IsExists(c27000302.chk,1,nil,sg)
		and (not e:GetHandler():IsLocation(LOCATION_EXTRA) or Duel.GetLocationCountFromEx(tp,tp,sg,e:GetHandler())>0)
end
function c27000302.chk(c,sg)
	return c:IsSetCard(0xbf) 
		and sg:IsExists(Card.IsAttribute,1,c,ATTRIBUTE_WATER)
end
function c27000302.SPCon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c27000302.SPfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
    and Duel.IsExistingMatchingCard(c27000302.SPfilter2,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c27000302.SPOpe(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c27000302.SPfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c27000302.SPfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	Duel.Release(g1,REASON_COST)
end 
-- {Monster Effect: Control}
function c27000302.CTRFilter1(c)
	return c:IsFaceup() 
		and c:IsControlerCanBeChanged() 
end
function c27000302.CTRTarg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c27000302.CTRFilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c27000302.CTRFilter1,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c27000302.CTRFilter1,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c27000302.TGFilter(c)
	return c:IsType(TYPE_MONSTER) 
		and c:IsAttribute(ATTRIBUTE_WATER) 
		and c:IsAbleToGrave()
end
function c27000302.CTROpe(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsAttribute(ATTRIBUTE_WATER) then
		if Duel.GetControl(tc,tp)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(tp,c27000302.TGFilter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoGrave(g,REASON_EFFECT)
			end
		end
	end
end
-- {Monster Effect: To Hand}
function c27000302.THCon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) 
		and c:IsPreviousLocation(LOCATION_MZONE) 
		and c:GetPreviousControler()==tp
end
function c27000302.THFilter(c)
	return c:IsType(TYPE_MONSTER) 
		and c:IsAttribute(ATTRIBUTE_WATER) 
		and c:IsAbleToHand()
end
function c27000302.THTarg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c27000302.THFilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c27000302.THFilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c27000302.THFilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c27000302.THOpe(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
--{Monster Effect: Limit Spell}
function c27000302.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) then return end
	e:GetHandler():RegisterFlagEffect(27000302,RESET_EVENT+0x3ff0000+RESET_PHASE+PHASE_END,0,1)
end
function c27000302.aclimit2(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) then return end
	e:GetHandler():ResetFlagEffect(27000302)
end
function c27000302.econ(e)
	return e:GetHandler():GetFlagEffect(27000302)~=0
end
function c27000302.elimit(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE)
end