--Cubic Hope
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.sptarget)
	e2:SetOperation(s.spoperation)
	c:RegisterEffect(e2)
end
s.listed_series={0xe3}
function s.tgfilter(c)
	return c:IsCode(15610297) and c:IsAbleToGrave() and
	((c:IsLocation(LOCATION_HAND) and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_DECK,0,1,nil)) or
	(c:IsLocation(LOCATION_DECK) and Duel.IsExistingMatchingCard(s.filter3,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil)) or
	(c:IsLocation(LOCATION_ONFIELD) and Duel.IsPlayerCanDraw(tp,3)))
end
function s.filter2(c)
	return c:IsLevelAbove(2) and c:IsSetCard(0xe3) and c:IsAbleToHand()
end
function s.filter3(c)
	return c:IsAbleToHand() and c:IsSetCard(0xe3) and c:IsType(TYPE_TRAP+TYPE_SPELL) and c:GetCode()~=id
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	if g:GetFirst():IsLocation(LOCATION_ONFIELD) then location=(LOCATION_ONFIELD)
	elseif g:GetFirst():IsLocation(LOCATION_HAND) then location=(LOCATION_HAND)
	elseif g:GetFirst():IsLocation(LOCATION_DECK) then location=(LOCATION_DECK)
	end
	if #g>0 then Duel.SendtoGrave(g,REASON_EFFECT)
		if location==LOCATION_ONFIELD then 
			Duel.Draw(tp,3,REASON_EFFECT) 
			Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
		elseif location==LOCATION_DECK then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g2=Duel.SelectMatchingCard(tp,s.filter3,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil)
			Duel.SendtoHand(g2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g2)
		elseif location==LOCATION_HAND then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g2=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_DECK,0,1,1,nil)
			Duel.SendtoHand(g2,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g2)
		end
	end
end


function s.fil(c)
	return c:IsCode(15610297)
end		
function s.filter(c,e,tp,lv)
	local lv=#Duel.GetMatchingGroup(s.fil,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	return c:IsSetCard(0xe3) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsLevelBelow(lv+1)
end
function s.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.fil,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function s.spoperation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_IMMUNE_EFFECT)
			e4:SetValue(s.efilter)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e4:SetOwnerPlayer(tp)
			g:GetFirst():RegisterEffect(e4)
	end
end
function s.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end

