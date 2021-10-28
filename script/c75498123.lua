--Overlay-Magic Startune Force
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.spfilter(c,e,tp)
	return c:IsCode(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.matfilter(c)
	return not c:IsType(TYPE_SYNCHRO)
end
function s.rmgchk(f,id)
	return function(c)
		return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and f(c,id)
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(s.rmgchk(Card.IsType,TYPE_SYNCHRO),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
		and Duel.IsExistingTarget(s.rmgchk(s.matfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local atg1=Duel.SelectTarget(tp,s.rmgchk(Card.IsType,TYPE_SYNCHRO),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local atg2=Duel.SelectTarget(tp,s.rmgchk(s.matfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,99,nil)
	local sg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	atg1:Merge(atg2)
	local lvgg=atg1:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,1,tp,LOCATION_EXTRA)
	if #lvgg>0 then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,lvgg,#lvgg,0,0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		Duel.SpecialSummonComplete()
		local tg=Duel.GetTargetCards(e):Filter(Card.IsRelateToEffect,nil,e)
		if #tg==5 then
			Duel.Overlay(tc,tg)
		end
	end
end
