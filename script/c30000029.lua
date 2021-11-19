--clear library
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={0x306}
function s.filter(c)
	return c:IsSetCard(0x306) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter1,tp,LOCATION_DECK,0,1,nil)
		and Duel.IsExistingMatchingCard(s.filter2,tp,0,LOCATION_MZONE,0,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter1,tp,LOCATION_DECK,0,1,1,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_MZONE,0,tc)
		local lc=g:GetFirst()
		local at=AnnounceAttribute(tp,1,ATTRIBUTE_ALL)
		for lc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e1:SetValue(at)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			lc:RegisterEffect(e1)
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
