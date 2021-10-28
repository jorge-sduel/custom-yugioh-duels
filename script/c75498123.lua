--Overlay-Magic Startune Force
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filterchk1(c,mg,matg,tp)
	local g=mg:Clone()
	local tg=matg:Clone()
	g:RemoveCard(c)
	tg:AddCard(c)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_XYZ_LEVEL)
	e2:SetValue(mg1:GetLevel())
	e2:SetReset(RESET_CHAIN)
	c:RegisterEffect(e2)
	local res=g:IsExists(s.filterchk2,1,nil,g,tg,0,tp)
	e1:Reset()
	e2:Reset()
	return res
end
function s.filterchk2(c,mg,matg,ct,tp)
	local g=mg:Clone()
	local tg=matg:Clone()
	g:RemoveCard(c)
	tg:AddCard(c)
	local ctc=ct+1
	local res=false
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetValue(mg1:GetLevel())
	e1:SetReset(RESET_CHAIN)
	c:RegisterEffect(e1)
	if ctc==4 then
		res=Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,tg,tp)
	else
		res=g:IsExists(s.filterchk2,1,nil,g,tg,ctc,tp)
	end
	e1:Reset()
	return res
end
function s.xyzfilter(c,mg,tp)
	return c:IsXyzSummonable(nil,mg,1,5) and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
end
function s.matfilter(c)
	return not c:IsType(TYPE_SYNCHRO)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg1=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,TYPE_SYNCHRO)
	local mg2=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	if chk==0 then return mg1:IsExists(s.filterchk1,1,nil,mg2,Group.CreateGroup(),tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local matg=Group.CreateGroup()
	local mg1=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,TYPE_SYNCHRO)
	local mg2=Duel.GetMatchingGroup(s.matfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local sg1=mg1:FilterSelect(tp,s.filterchk1,1,1,nil,mg2,matg,tp)
	local tc1=sg1:GetFirst()
	local reset={}
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_XYZ_LEVEL)
	e2:SetValue(mg1:GetLevel())
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc1:RegisterEffect(e2)
	table.insert(reset,e1)
	table.insert(reset,e2)
	matg:AddCard(tc1)
	mg2:RemoveCard(tc1)
	for i=1,4 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg2=mg2:FilterSelect(tp,s.filterchk2,1,1,nil,mg2,matg,i-1,tp)
		local tc2=sg2:GetFirst()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_XYZ_LEVEL)
		e2:SetValue(mg1:GetLevel())
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc2:RegisterEffect(e2)
		matg:AddCard(tc2)
		mg2:RemoveCard(tc2)
		table.insert(reset,e2)
	end
	local xyzg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil,matg,tp)
	if #xyzg>0 then
		Duel.HintSelection(matg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		Duel.XyzSummon(tp,xyz,nil,matg)
	else
		for _,eff in ipairs(reset) do
			eff:Reset()
		end
	end
end
