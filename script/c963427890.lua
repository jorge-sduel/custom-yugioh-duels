--Subzero Conjurer
if not RUNIC_IMPORTED then Duel.LoadScript("proc_runic.lua") end
function c963427890.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2521011,0))
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetTarget(c963427890.eqtg)
	e1:SetOperation(c963427890.eqop)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetDescription(aux.Stringid(952312343,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c963427890.thcon)
	e2:SetTarget(c963427890.thtg)
	e2:SetOperation(c963427890.thop)
	c:RegisterEffect(e2)
end
--function c963427890.eqfilter(c)
--	return c:GetType()==0x4
--end
function c963427890.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.GetLocationCount(e:GetHandlerPlayer(),LOCATION_SZONE)>0
		and Duel.IsExistingTarget(Card.IsFaceup,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,1,nil) 
		and Duel.IsExistingTarget(c963427890.eqfilter,e:GetHandlerPlayer(),LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c963427890.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsExistingMatchingCard(c963427890.eqfilter,c:GetControler(),LOCATION_DECK,0,1,nil) then
		local tc=Duel.SelectMatchingCard(tp,c963427890.eqfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		Duel.Equip(tp,tc,c)
		--Add New Equip Limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetLabelObject(c)
		e1:SetValue(1)
		tc:RegisterEffect(e1)
	end
end
function c963427890.eqlimit(e,c)
	return e:GetLabelObject()==c
end
function c963427890.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(963427890)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c963427890.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetLabelObject(),REASON_EFFECT)
end
function c963427890.thcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	return e:GetHandler():IsPreviousLocation(LOCATION_MZONE) and rc:IsPreviousLocation(LOCATION_HAND) and e:GetHandler():GetTurnID()==Duel.GetTurnCount() and rc.Is_Runic and rc:IsRace(RACE_SPELLCASTER)
end
function c963427890.thfilter(c,mg,ec)
	return mg:IsExists(Card.IsCode,1,ec,c:GetCode()) and c:IsAbleToHand()
end
function c963427890.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	if chk==0 then return Duel.IsExistingMatchingCard(c963427890.thfilter,c:GetControler(),LOCATION_DECK,0,1,nil,rc:GetMaterial(),c) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c963427890.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local g=Duel.SelectMatchingCard(tp,c963427890.thfilter,tp,LOCATION_DECK,0,1,1,nil,rc:GetMaterial(),c)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
