--Runic Instantation
function c943980714.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	e1:SetTarget(c943980714.runtg)
	e1:SetOperation(c943980714.runop)
	c:RegisterEffect(e1)
end
function c943980714.runtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsRuneSummonable,tp,0x3ff~LOCATION_MZONE,0,1,nil,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x3ff~LOCATION_MZONE)
end
function c943980714.runop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsRuneSummonable,tp,0x3ff~LOCATION_MZONE,0,nil,nil,e:GetHandler())
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		local sc=tg:GetFirst()
		Duel.RuneSummon(tp,sc,nil)
		--[[
		--Get Parameters
		local f1,min1,max1,f2,min2,max2, exChk, alterG
		if (not sc.ex_rune_parameters and sc:IsLocation(sc.rune_parameters[9])) or sc:IsLocation(LOCATION_HAND) then
			f1=sc.rune_parameters[3]
			min1=sc.rune_parameters[4]
			max1=sc.rune_parameters[5]
			f2=sc.rune_parameters[6]
			min2=sc.rune_parameters[7]
			max2=sc.rune_parameters[8]
			exChk=sc.rune_parameters[9]==LOCATION_EXTRA
			alterG=sc.rune_parameters[10]
			alterCon=sc.rune_parameters[11]
		elseif sc:IsLocation(sc.ex_rune_parameters[9]) then
			f1=sc.ex_rune_parameters[3]
			min1=sc.ex_rune_parameters[4]
			max1=sc.ex_rune_parameters[5]
			f2=sc.ex_rune_parameters[6]
			min2=sc.ex_rune_parameters[7]
			max2=sc.ex_rune_parameters[8]
			exChk=sc.ex_rune_parameters[9]==LOCATION_EXTRA
			alterG=sc.ex_rune_parameters[10]
			alterCon=sc.ex_rune_parameters[11]
		end
		--Rune Summon
		aux.RunTarget(f1,min1,max1,f2,min2,max2,exChk,alterG,alterCon)(e,tp,eg,ep,ev,re,r,rp,nil,sc)
		aux.RunOperation(f1,min1,max1,f2,min2,max2,exChk,alterG,REASON_EFFECT)(e,tp,eg,ep,ev,re,r,rp,sc,smat,mg)
		Duel.SpecialSummon(sc,SUMMON_TYPE_RUNE,tp,tp,false,true,POS_FACEUP)
		]]
	end
end
