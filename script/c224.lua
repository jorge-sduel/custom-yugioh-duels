--Borrel xyz link
function c224.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c224.xyzcon)
	e1:SetOperation(c224.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c224.efilter1)
	c:RegisterEffect(e2)
	--atk down
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(31833038,0))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetHintTiming(TIMING_DAMAGE_STEP+TIMING_END_PHASE)

	e3:SetCountLimit(1)
	e3:SetTarget(c224.atktg)
	e3:SetOperation(c224.atkop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
e4:SetDescription(aux.Stringid(224,0))
	e4:SetCost(c224.cost)
	e4:SetTarget(c224.target)
	e4:SetOperation(c224.activate)
	c:RegisterEffect(e4,false,REGISTER_FLAG_DETACH_XMAT)
end
function c224.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c:IsLink(4)
end	
function c224.xyzcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c224.ovfilter,tp,LOCATION_MZONE,0,2,nil)
end
function c224.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	if chk==0 then return Duel.IsExistingMatchingCard(c224.ovfilter,tp,LOCATION_MZONE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=Duel.SelectMatchingCard(tp,c224.ovfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g2=Duel.SelectMatchingCard(tp,c224.ovfilter,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	og=Group.CreateGroup()
	og:Merge(g1)
	og:Merge(g2)
	if g1:GetCount()>0 then
		local mg1=g1:GetFirst():GetOverlayGroup()
		if mg1:GetCount()~=0 then
			og:Merge(mg1)
			Duel.Overlay(g2:GetFirst(),mg1)
		end
		Duel.Overlay(g2:GetFirst(),g1)
		local mg2=g2:GetFirst():GetOverlayGroup()
		if mg2:GetCount()~=0 then
			og:Merge(mg2)
			Duel.Overlay(c,mg2)
		end
		c:SetMaterial(og)
		Duel.Overlay(c,g2:GetFirst())	
	end
end
function c224.efilter1(e,re,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c224.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c224.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetChainLimit(c224.chlimit)
end
function c224.chlimit(e,ep,tp)
	return tp==ep
end
function c224.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-3000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
	end
end
function c224.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c224.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function c224.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetControler()
	Duel.SetLP(1-tp,Duel.GetLP(1-p)/2,REASON_EFFECT)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(Duel.GetLP(1-p))
		tc:RegisterEffect(e1)
	end
end
