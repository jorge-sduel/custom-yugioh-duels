--sup overlay
function c223.initial_effect(c)
	--Activate 2
	local e2=Effect.CreateEffect(c)
e2:SetDescription(aux.Stringid(12340417,10))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c223.target)
	e2:SetOperation(c223.activate2)
	c:RegisterEffect(e2)
end
function c223.filter1(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c223.filter2(c,e,tp,odd)
	return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c223.xyzfilter(c,mg,tp,chk)
	return c:IsXyzSummonable(nil,mg,2,2) and (not chk or Duel.GetLocationCountFromEx(tp,tp,mg,c)>0)
end
function c223.xyzlvl(e,c,rc)
	return c:GetRank()
end
function c223.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if chkc then return false end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.IsPlayerCanSpecialSummonCount(tp,2) 
		and (not ect or ect>=2) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.GetLocationCountFromEx(tp)>0 and Duel.GetUsableMZoneCount(tp)>1 
		and Duel.IsExistingTarget(c223.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local c1=Duel.SelectTarget(tp,c223.filter1,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,Group:FromCards(c1,c2),2,0,0)
end
function c223.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 
		or Duel.GetUsableMZoneCount(tp)<=1 then return false end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	local tc=sg:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_MONSTER) then
	local ac=Duel.AnnounceLevel(tp,7,10)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_RANK_LEVEL)
			e3:SetValue(ac)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e3)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_CHANGE_LEVEL)
		  e4:SetValue(ac)
			e4:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e4)
		end
		tc=sg:GetNext()
	end
	Duel.SpecialSummonComplete()
	Duel.BreakEffect()
	local xyzg=Duel.GetMatchingGroup(c223.xyzfilter,tp,LOCATION_EXTRA,0,nil,g,tp,true)
	if #xyzg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.XyzSummon(tp,xyz,nil,g)
	end
end