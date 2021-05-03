--Synchro difraction
function c325.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c325.target)
	e1:SetOperation(c325.activate)
	c:RegisterEffect(e1)
end
function c325.cfilter(c,e,tp,g,maxc)
	local tmax=maxc
	if c:GetSequence()<5 then tmax=tmax-1 end
	if tmax<=0 then return end
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsAbleToExtraAsCost()
		and g:CheckWithSumEqual(Card.GetLevel,c:GetLevel(),1,maxc)
end
function c325.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c325.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local maxc=ft+1
	if maxc>1 then maxc=1 end
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		local spg=Duel.GetMatchingGroup(c325.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil,e,tp)
		return Duel.IsExistingMatchingCard(c325.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,spg,maxc)
	end
	e:SetLabel(0)
	local spg=Duel.GetMatchingGroup(c325.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local cg=Duel.SelectMatchingCard(tp,c325.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,spg,maxc)
	local lv=cg:GetFirst():GetLevel()
	Duel.SendtoDeck(cg,nil,0,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=spg:SelectWithSumEqual(tp,Card.GetLevel,lv,1,maxc)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,#sg,0,0)
end
function c325.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e)
	local ct=#g
	if ct==0 or (ct>1)
		or ct>Duel.GetLocationCount(tp,LOCATION_MZONE) then return end
	Duel.SpecialSummon(g,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
end
