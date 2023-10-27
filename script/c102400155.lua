--created & coded by Lyris, art from Shadowverse's "Wood of Brambles" & "Siren's Tears"
--RUM－ワンドラス・フォース
local cid,id=GetID()
function cid.initial_effect(c)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(cid.target)
	e2:SetOperation(cid.activate)
	c:RegisterEffect(e2)
end
function cid.filter1(c,e,tp)
	--local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	return c:IsXyzSummonable(nil)
	--and (not ect or ect>1)
		--and Duel.IsExistingMatchingCard(cid.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function cid.filter3(c,e,tp)
	--local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	return c:IsType(TYPE_XYZ)
	--and (not ect or ect>1)
		and Duel.IsExistingMatchingCard(cid.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function cid.filter2(c,e,tp,mc,rk)
	if c.rum_limit and not c.rum_limit(mc,e) then return false end
	return c:IsType(TYPE_XYZ) and mc:IsType(TYPE_XYZ,c,SUMMON_TYPE_XYZ,tp) and c:IsRank(rk+1) and mc:IsCanBeXyzMaterial(c,tp) 
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)>0
		--and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(cid.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or Duel.GetLocationCountFromEx(tp)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) 
		or not Duel.XyzSummon(tp,tc,nil) then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cid.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc,tc:GetRank())
	local sc=g:GetFirst()
	if sc then
		Duel.BreakEffect()
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		if Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)>0 then
			sc:CompleteProcedure()
			if c:IsRelateToEffect(e) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
				c:CancelToGrave()
				Duel.Overlay(sc,Group.FromCards(c))
			end
		end
	end
end
























	
	--[[local 
	--if tc then
		local tc2=g2:GetFirst()
		if tc2 then
			Duel.BreakEffect()
		local tc1=
		local tc3=tc1:GetFirst()
			local xmg=tc3:GetOverlayGroup()
			if xmg:GetCount()~=0 then
				Duel.Overlay(tc2,xmg)
		--end
			tc2:SetMaterial(tc3)
			Duel.Overlay(tc2,tc3)
		if Duel.SpecialSummon(tc2,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP) then	
			tc2:CompleteProcedure()
		end
	end
end]]
