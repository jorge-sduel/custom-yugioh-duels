--ss xyz earth
function c247.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,4,2,c247.ovfilter,aux.Stringid(93854893,0),2)
	c:EnableReviveLimit()
	--atk limit
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12421694,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCost(c247.cost)
	e1:SetTarget(c247.atktg)
	e1:SetOperation(c247.atkop)
	c:RegisterEffect(e1,false,REGISTER_FLAG_DETACH_XMAT)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(aux.chainreg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c247.reccon)
	e3:SetOperation(c247.recop)
	c:RegisterEffect(e3)
end
function c247.ovfilter(c,tp,xyzc)
	return c:IsFaceup() and c:IsType(TYPE_LINK,xyzc,SUMMON_TYPE_XYZ,tp) and c:IsAttribute(ATTRIBUTE_EARTH,xyzc,SUMMON_TYPE_XYZ,tp)
end
function c247.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c247.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c247.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,Duel.GetTurnPlayer()==tp and 2 or 1)
		tc:RegisterEffect(e1)
	end
end
function c247.reccon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsActiveType(TYPE_SPELL) and re:GetHandler():IsSetCard(0x115) and rp==tp and e:GetHandler():GetFlagEffect(1)>0
end
function c247.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,200,REASON_EFFECT)
end
