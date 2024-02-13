--
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,s.matfilter,5,4,s.ovfilter,aux.Stringid(id,0))
	c:EnableReviveLimit()
	--Special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_QUICK_O)
			e2:SetCode(EVENT_FREE_CHAIN)
			e2:SetRange(LOCATION_MZONE)
			e2:SetTarget(s.tg)
			e2:SetOperation(s.op)
			c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCost(s.cost)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3,false,REGISTER_FLAG_DETACH_XMAT)
		--atk def
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e4:SetCondition(s.thcon)
	e4:SetTarget(s.target1)
	e4:SetOperation(s.operation1)
	c:RegisterEffect(e4)
end
function s.ovfilter(c,tp,lc)
	return c:IsRank(5) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x86) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,c,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	if tc:IsType(TYPE_XYZ) then
 Duel.Overlay(tc,e:GetHandler()) 
	end
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		if not c:IsHasEffect(id) then return false end
		local tgeffs={c:GetCardEffect(id)}
		for _,tge in ipairs(tgeffs) do
			if tge:GetLabel()==ev then return tge:GetLabelObject():GetTarget()(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
		end
		return false
	end
	if chk==0 then
		if not c:IsHasEffect(511002571) then return false end
		local effs={c:GetCardEffect(511002571)}
		for _,teh in ipairs(effs) do
			local temp=teh:GetLabelObject()
			if temp:GetCode()&511001822==511001822 or temp:GetLabel()==511001822 then temp=temp:GetLabelObject() end
			e:SetCategory(temp:GetCategory())
			e:SetProperty(temp:GetProperty())
			local con=temp:GetCondition()
			local cost=temp:GetCost()
			local tg=temp:GetTarget()
			if (not con or con(e,tp,eg,ep,ev,re,r,rp))
				and (not cost or cost(e,tp,eg,ep,ev,re,r,rp,0))
				and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)) then
				return true
			end
		end
		return false
	end
	local effs={c:GetCardEffect(511002571)}
	local acd={}
	local ac={}
	for _,teh in ipairs(effs) do
		local temp=teh:GetLabelObject()
		if temp:GetCode()&511001822==511001822 or temp:GetLabel()==511001822 then temp=temp:GetLabelObject() end
		e:SetCategory(temp:GetCategory())
		e:SetProperty(temp:GetProperty())
		local con=temp:GetCondition()
		local cost=temp:GetCost()
		local tg=temp:GetTarget()
		if (not con or con(e,tp,eg,ep,ev,re,r,rp))
			and (not cost or cost(e,tp,eg,ep,ev,re,r,rp,0))
			and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)) then
			table.insert(ac,teh)
			table.insert(acd,temp:GetDescription())
		end
	end
	local te=nil
	if #ac==1 then te=ac[1] elseif #ac>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		local op=Duel.SelectOption(tp,table.unpack(acd))+1
		te=ac[op]
	end
	local teh=te
	te=teh:GetLabelObject()
	if te:GetCode()&511001822==511001822 or te:GetLabel()==511001822 then te=te:GetLabelObject() end
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local cost=te:GetCost()
	if cost then cost(e,tp,eg,ep,ev,re,r,rp,1) end
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1,chkc) end
	te:UseCountLimit(tp)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsHasEffect(id) then
		local tgeffs={c:GetCardEffect(id)}
		for _,tge in ipairs(tgeffs) do
			if tge:GetLabel()==Duel.GetCurrentChain() then
				local te=tge:GetLabelObject()
				local operation=te:GetOperation()
				if operation then operation(e,tp,eg,ep,ev,re,r,rp) end
			end
		end
	end
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.BreakEffect()
	end
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.atkfilter(e,c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ATTACK_ALL)
		e1:SetValue(s.atkfilter)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc and tc:IsFaceup() and tc:IsRelateToEffect(e) and 		Duel.Destroy(tc,REASON_EFFECT)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(tc:GetAttack()/2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end