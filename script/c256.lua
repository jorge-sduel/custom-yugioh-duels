--ss final Assault
function c256.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DAMAGE)
	e1:SetTarget(c256.tg)
	e1:SetOperation(c256.op)
	c:RegisterEffect(e1)
	--salvage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(41201386,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c256.thtg)
	e3:SetOperation(c256.thop)
	c:RegisterEffect(e3)
end
function c256.fld_fil(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end

function c256.grv_fil(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_SPELL)
end

function c256.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,69832741) and Duel.IsExistingTarget(c256.fld_fil,tp,LOCATION_MZONE,0,1,nil) 
	and Duel.IsExistingMatchingCard(c256.grv_fil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SelectTarget(tp,c256.fld_fil,tp,LOCATION_MZONE,0,1,1,nil)
end

function c256.grv_lvl_sum(c)
	return c:IsType(TYPE_SPELL)
end

function c256.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local tg=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0):Filter(c256.grv_fil,nil)
	if tc:IsRelateToEffect(e) and tg:GetCount()>0 then
		if not Duel.Remove(tg,nil,REASON_EFFECT) then return end
			i=tg:FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(i*300)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetOperation(c256.dmg_op)
		e2:SetLabel(i*300)
		Duel.RegisterEffect(e2,tp)
	end
end
function c256.dmg_op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(tp,i*300,REASON_EFFECT)
end
function c256.thfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c256.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c256.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c256.thfilter,tp,LOCATION_REMOVED,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c256.thfilter,tp,LOCATION_REMOVED,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c256.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
