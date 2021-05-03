--Synchro difraction
function c325.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c325.target)
	e1:SetOperation(c325.activate)
	c:RegisterEffect(e1)
end
function c325.spfilter(c,e,tp,mc)
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,true)
end
function c325.rfilter(c,mc)
	local mlv=mc:GetLevel(c)
	if mlv==mc:GetLevel() then return false end
	local lv=c:GetLevel()
	return lv==(mlv&0xffff) or lv==(mlv>>16)
end
function c325.filter(c,e,tp)
	local sg=Duel.GetMatchingGroup(c325.spfilter,tp,LOCATION_EXTRA,0,c,e,tp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if c:IsLocation(LOCATION_MZONE) then ft=ft+1 end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	return sg:IsExists(c325.rfilter,1,nil,c) or sg:CheckWithSumEqual(Card.GetLevel,c:GetLevel(),1,ft)
end
function c325.mfilter(c)
	return c:HasLevel() and c:IsType(TYPE_SYNCHRO) and c:IsAbleToGrave()
end
function c325.mzfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:GetSequence()<5
end
function c325.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<0 then return false end
		local mg=Duel.GetSynchroMaterial(tp)
		if ft>0 then
			local mg2=Duel.GetMatchingGroup(c325.mfilter,tp,LOCATION_MZONE,0,nil)
			mg:Merge(mg2)
		else
			mg=mg:Filter(c325.mzfilter,nil,tp)
		end
		return mg:IsExists(c325.filter,2,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c325.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<0 then return end
	local mg=Duel.GetSynchroMaterial(tp)
	if ft>0 then
		local mg2=Duel.GetMatchingGroup(c325.mfilter,tp,LOCATION_MZONE,0,nil)
		mg:Merge(mg2)
	else
		mg=mg:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local mat=mg:FilterSelect(tp,c325.filter,1,1,nil,e,tp)
	local mc=mat:GetFirst()
	if not mc then return end
	local sg=Duel.GetMatchingGroup(c325.spfilter,tp,LOCATION_EXTRA,0,mc,e,tp,mc)
	if mc:IsLocation(LOCATION_MZONE) then ft=ft+1 end
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	local b1=sg:IsExists(c325.rfilter,1,nil,mc)
	local b2=sg:CheckWithSumEqual(Card.GetLevel,mc:GetLevel(),1,ft)
	if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(325,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:FilterSelect(tp,c325.rfilter,1,1,nil,mc)
		local tc=tg:GetFirst()
		tc:SetMaterial(mat)
		if not mc:IsLocation(LOCATION_EXTRA) then
			Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_SYNCHRO)
		else
			Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_SYNCHRO)
		end
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:SelectWithSumEqual(tp,Card.GetLevel,mc:GetLevel(),1,ft)
		local tc=tg:GetFirst()
		for tc in aux.Next(tg) do
			tc:SetMaterial(mat)
		end
		if not mc:IsLocation(LOCATION_MZONE) then
			Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_SYNCHRO)
		else
			Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_SYNCHRO)
		end
		Duel.BreakEffect()
		tc=tg:GetFirst()
		for tc in aux.Next(tg) do
			Duel.SpecialSummonStep(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,true,POS_FACEUP)
			tc:CompleteProcedure()
		end
		Duel.SpecialSummonComplete()
	end
end
