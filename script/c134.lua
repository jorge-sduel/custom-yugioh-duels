--predaplant xyz
function c134.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,3,2) 
	c:EnableReviveLimit()
	--power up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(134,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE+0x1c0)
	e1:SetCost(c134.cost)
	e1:SetTarget(c134.target)
	e1:SetOperation(c134.operation)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1,false,REGISTER_FLAG_DETACH_XMAT)
end
function c134.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c134.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c134.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(c134.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
end
function c134.operation(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.SelectTarget(tp,c134.filter,tp,LOCATION_MZONE,0,1,2,nil)
	local tc=g:GetFirst()
	if tc and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(1000)
		tc:RegisterEffect(e1)
	local tc2=g:GetNext()
	if tc2 and tc2:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(1000)
		tc2:RegisterEffect(e1)
	end
	end
end