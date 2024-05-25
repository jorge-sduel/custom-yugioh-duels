--
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--Grant effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCountLimit(1,{id,1})
	e2:SetCondition(s.mtcon)
	e2:SetOperation(s.mtop)
	c:RegisterEffect(e2)
end
s.listed_series={0x76,0x92}
function s.thfilter(c)
	return c:IsSetCard(0x92) and c:IsSpellTrap() and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_XYZ
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	--if not rc then return end
	--negate
	local e1=Effect.CreateEffect(rc)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(s.negcon)
	e1:SetCountLimit(1)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_EQUIP)
	e1:SetCost(aux.dxmcostgen(1,1,nil))
	e1:SetTarget(s.negtg)
	e1:SetOperation(s.negop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true,REGISTER_FLAG_DETACH_XMAT)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
	rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
end
function s.filter1(c,e,tp)
	return --c:IsSetCard(0x72) and 
	Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function s.filter2(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,1-tp,false,false,POS_FACEUP)
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep==1-tp
		and Duel.IsChainDisablable(ev)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	--if chkc then return chkc:IsLocation(LOCATION_DECK) and chkc:IsControler(tp) and chkc:IsCode(e:GetLabel()) end
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	--if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	local g1=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g1:GetFirst()
	if tc then
		local code=tc:GetCode()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,code)
		if #g>0 then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			Duel.SpecialSummon(g,0,1-tp,1-tp,false,false,POS_FACEUP)
		end
	end
end

