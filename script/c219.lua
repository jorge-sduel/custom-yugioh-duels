--supre king tune
function c219.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c219.target)
	e1:SetOperation(c219.activate)
	c:RegisterEffect(e1) 
end
function c219.filter1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and Duel.IsExistingTarget(c219.filter2,tp,LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function c219.filter2(c,e,tp,odd)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c219.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if chkc then return false end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.IsPlayerCanSpecialSummonCount(tp,2) 
		and (not ect or ect>=2) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.GetLocationCountFromEx(tp)>0 and Duel.GetUsableMZoneCount(tp)>1 
		and Duel.IsExistingTarget(c219.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local c1=Duel.SelectTarget(tp,c219.filter1,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,Group:FromCards(c1,c2),2,0,0)
end
function c219.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 
		or Duel.GetUsableMZoneCount(tp)<=1 then return false end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	local tc=sg:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_SYNCHRO) or tc:IsType(TYPE_XYZ) then
	local ac=Duel.AnnounceLevel(tp,0,8)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_RANK_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CHANGE_LEVEL)
			e2:SetValue(ac)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_ADD_TYPE)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			e3:SetValue(TYPE_TUNER)
			tc:RegisterEffect(e3)
		end
		tc=sg:GetNext()
	end
	Duel.SpecialSummonComplete()
	Duel.BreakEffect()
	local g=Duel.GetMatchingGroup(function(sc) return sc:IsSynchroSummonable(nil,sg) end,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SynchroSummon(tp,sc,nil,sg)
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) or not e:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
		e1:SetRange(LOCATION_SZONE)
		e1:SetCode(EVENT_LEAVE_FIELD)
		e1:SetCondition(c219.descon)
		e1:SetTarget(c219.destg)
		e1:SetOperation(c219.desop)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetLabelObject(sc)
		c:RegisterEffect(e1)
	end
end
function c219.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc and eg:IsContains(tc) and tc:IsReason(REASON_DESTROY)
end
function c219.thfilter(c)
	return c:IsAbleToHand() and c:IsCode(511015106)
end
function c219.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGrave() 
		and Duel.IsExistingMatchingCard(c219.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c219.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_GRAVE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c219.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
