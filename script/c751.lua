--フォース
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
		--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(s.sctg)
	e2:SetOperation(s.scop)
	c:RegisterEffect(e2)
	--salvage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(aux.exccon)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
function s.filter(c)
	return c:IsFaceup() and (c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ) or c:IsType(TYPE_FUSION))
end
function s.xyzfilter(c,tp)
	return c:IsFaceup() and (c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ) or c:IsType(TYPE_FUSION)) and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,c)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.xyzfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(s.xyzfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	--if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tc3=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,0,1,1,tc):GetFirst()
		local ac=Duel.AnnounceLevel(tp,7,8)
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0)
		tc3:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0)
		--local sc=tc2:Select(tp,1,1,nil)
		--local tc3=tc2:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetLabel(TYPE_SYNCHRO)
		e1:SetTarget(s.con)
		e1:SetValue(7)
		Duel.RegisterEffect(e1,tp)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_RANK_LEVEL)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e3:SetLabel(TYPE_XYZ)
		e3:SetTarget(s.con)
		Duel.RegisterEffect(e3,tp)
		local e12=Effect.CreateEffect(e:GetHandler())
		e12:SetType(EFFECT_TYPE_FIELD)
		e12:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
		e12:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e12:SetLabel(TYPE_XYZ)
		e12:SetTarget(s.con)
		e12:SetValue(ac)
		e12:SetReset(RESET_EVENT+RESETS_STANDARD)
		Duel.RegisterEffect(e12,tp)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_FIELD)
		e4:SetCode(EFFECT_CHANGE_LEVEL)
		e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e4:SetLabel(TYPE_FUSION)
		e4:SetTarget(s.con)
		e4:SetValue(8)
		Duel.RegisterEffect(e4,tp)
		local e7=Effect.CreateEffect(e:GetHandler())
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetCode(id)
		e7:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e7)
		local e8=Effect.CreateEffect(e:GetHandler())
		e8:SetType(EFFECT_TYPE_SINGLE)
		e8:SetCode(id)
		e8:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc3:RegisterEffect(e8)
	end
	local mg=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsType,TYPE_MONSTER),tp,LOCATION_MZONE,0,nil)
		local eg=Duel.GetMatchingGroup(s.scfilter,tp,LOCATION_EXTRA,0,nil,mg)
		if #mg>0 and #eg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=eg:Select(tp,1,1,nil)
			Duel.XyzSummon(tp,sg:GetFirst(),nil,mg)
	end
end
function s.con(e,c)
	return c:IsType(e:GetLabel()) and c:IsHasEffect(id)
end
function s.scfilter(c,mg)
	return c:IsXyzSummonable(nil,mg)
end
function s.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,nil,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.scop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,sg:GetFirst(),nil)
	end
end
function s.thfilter(c)
	return ((c:IsSetCard(0x95) or c:IsCode(752) or c:IsCode(749)) and not c:IsCode(id)) and c:IsAbleToHand()
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
