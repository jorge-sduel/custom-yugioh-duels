--Frozen Mirror
function c138.initial_effect(c)
	e1=Ritual.CreateProc({handler=c,filter=c138.ritualfil,lvtype=RITPROC_EQUAL,extraop=c138.extraop,extrafil=c138.extrafil,location=LOCATION_EXTRA|LOCATION_HAND,})
	--[[Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c138.target)
	e1:SetOperation(c138.activate)
	c:RegisterEffect(e1)]]
end
c138.fit_monster={27000302}
function c138.filter(c,e,tp,m)
	local cd=c:GetCode()
	if 
		--cd~=27000302 or 
		not ((c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) or (c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true) and c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,m)>0)) and c:IsType(TYPE_RITUAL) and c:IsMonster()) then return false end
	if m:IsContains(c) then
		m:RemoveCard(c)
		result=m:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
		m:AddCard(c)
	else
		result=m:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
	end
	return result
end
function c138.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		return Duel.IsExistingMatchingCard(c138.filter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
end
function c138.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c138.filter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil,e,tp,mg)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		mg:RemoveCard(tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end

function c138.ritualfil(c)
    return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER)
end
function c138.mfilter(c)
    return c:IsLocation(LOCATION_MZONE) or c:IsLocation(LOCATION_HAND)
end
function c138.exfilter0(c)
    return c:IsFaceup() and c:IsLevelAbove(1) and c:IsAbleToGrave()
end
function c138.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetMatchingGroup(s.exfilter0,tp,LOCATION_EXTRA,0,nil)
end
function c138.extraop(mg,e,tp,eg,ep,ev,re,r,rp)
    local mat2=mg:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
    mg:Sub(mat2)
    Duel.ReleaseRitualMaterial(mg)
    Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
end
