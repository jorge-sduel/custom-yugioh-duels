--guardian alianze
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.sdcon)
	c:RegisterEffect(e2)
	--todeck
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetValue(LOCATION_DECKSHF)
	c:RegisterEffect(e3)
end
s.listed_series={0x52}
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,800) end
	Duel.PayLPCost(tp,800)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x52) or c:IsType(TYPE_EQUIP)
end
function s.rescon(sg,e,tp,mg)
	return sg:IsExists(s.lfilter1,1,nil,sg)
end
function s.lfilter1(c,sg)
	return sg:IsExists(s.lfilter2,1,c,c)
end
function s.lfilter2(c,tc)
	return aux.IsCodeListed(c,tc:GetCode()) or c:IsType(TYPE_EQUIP)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and aux.SelectUnselectGroup(mg,e,tp,2,2,s.rescon,0) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,0,LOCATION_DECK+LOCATION_GRAVE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local mg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,e,tp)
	if #mg<2 then return end
	local g1=aux.SelectUnselectGroup(mg,e,tp,2,2,s.rescon,1,tp,HINTMSG_SPSUMMON)
	if #g1>1 then
		local tc=g1:GetFirst()
		for tc in aux.Next(g1) do
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTarget(s.splimit)
		e1:SetTargetRange(1,0)
		Duel.RegisterEffect(e1,tp)
		--Lizard check
		aux.addTempLizardCheck(c,tp,s.lizfilter)
	end
end
function s.splimit(e,c)
	return not c:IsSetCard(0x52) and c:IsLocation(LOCATION_EXTRA)
end
function s.lizfilter(e,c)
	return not c:IsOriginalSetCard(0x52)
end
function s.sdcon(e)
	return not Duel.IsExistingMatchingCard(s.filter,e:GetHandler():GetControler(),LOCATION_GRAVE,0,1,nil)
end
function s.filter(c)
	return c:IsType(TYPE_MONSTER)
end
function s.rmtarget(e,c)
	return c:IsReason(REASON_BATTLE)
end
