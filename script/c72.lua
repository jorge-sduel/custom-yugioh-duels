--lvup
function c72.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(0)
	e1:SetCost(c72.cost)
	e1:SetTarget(c72.target)
	e1:SetOperation(c72.activate)
	c:RegisterEffect(e1)
end
function c72.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c72.filter1(c,e,tp)
	local lv=c:GetLevel()
	return  c:IsType(TYPE_SYNCHRO) and  Duel.IsExistingMatchingCard(c72.filter2,tp,LOCATION_EXTRA,0,1,nil,lv,e,tp)
		and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function c72.filter2(c,lv,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsLevel(lv+1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c72.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,c72.filter1,1,nil,e,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,c72.filter1,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetLevel())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c72.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c72.filter2,tp,LOCATION_EXTRA,0,1,1,nil,lv,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
	end
end
