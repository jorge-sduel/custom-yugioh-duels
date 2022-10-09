--Ancient Engraved Sword
if not RUNIC_IMPORTED then Duel.LoadScript("proc_runic.lua") end
function c956891234.initial_effect(c)
	aux.AddEquipProcedure(c)
	--destroy sub
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e3:SetValue(c956891234.repval)
	c:RegisterEffect(e3)
	--to deck
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(952312343,0))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_BE_MATERIAL)
	e5:SetCondition(c956891234.thcon)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTarget(c956891234.thtg)
	e5:SetOperation(c956891234.thop)
	c:RegisterEffect(e5)
end
function c956891234.repval(e,re,r,rp)
	return bit.band(r,REASON_BATTLE)~=0 or bit.band(r,REASON_EFFECT)~=0
end
function c956891234.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():GetReasonCard()==REASON_RUNIC
end
function c956891234.thfilter(c)
	return c:IsAbleToHand()
end
function c956891234.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c956891234.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
