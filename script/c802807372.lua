--Assault Mode Activate II
function c802807372.initial_effect(c)
--バスター・モードII
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c802807372.cost)
	e1:SetTarget(c802807372.target)
	e1:SetOperation(c802807372.activate)
	c:RegisterEffect(e1)
end
c802807372.list={[44508094]=61257789,[70902743]=77336644,[6021033]=1764972,[31924889]=14553285,[23693634]=38898779,[95526884]=37169670,[5717743]=86221218,[58431891]=86221220,[24696097]=7041324,[73580471]=92834757,[9012916]=92834758,[25862681]=92834759,[2403771]=24108326}
function c802807372.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c802807372.filter1(c,e,tp,ft)
	local code=c:GetCode()
--	local tcode=c802807372.list[code]
	return c:IsType(TYPE_SYNCHRO) and (ft>0 or (c:GetSequence()<5 and c:IsControler(tp))) and Duel.IsExistingMatchingCard(c802807372.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,c:GetCode(),e,tp)
end
function c802807372.filter2(c,tcode,e,tp)
	return c:IsSetCard(0x104f) and c.assault_mode and c.assault_mode==tcode and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c802807372.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return ft>-1 and Duel.CheckReleaseGroupCost(tp,c802807372.filter1,1,false,nil,nil,e,tp,ft)
	end
	local rg=Duel.SelectReleaseGroupCost(tp,c802807372.filter1,1,1,false,nil,nil,e,tp,ft)
	Duel.SetTargetParam(rg:GetFirst():GetCode())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c802807372.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local code=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c802807372.filter2,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,code,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP_ATTACK)>0 then
		tc:CompleteProcedure()
	end
end