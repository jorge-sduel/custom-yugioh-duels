--Poly
function c12340114.initial_effect(c)
	--from field or graveyard
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12340114,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c12340114.target)
	e1:SetOperation(c12340114.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340114,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,12340114+EFFECT_COUNT_CODE_OATH)
	e2:SetCost(c12340114.thcost)
	e2:SetOperation(c12340114.thop)
	c:RegisterEffect(e2)
end

function c12340114.filter0(c)
	return c:IsOnField() and c:IsAbleToGrave()
end
function c12340114.filter1(c,e)
	return c:IsOnField() and c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
function c12340114.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x202) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,tp)
end
function c12340114.filter3(c,e)
	return c:IsRace(RACE_ZOMBIE) and c:IsCanBeFusionMaterial() and c:IsAbleToDeckOrExtraAsCost()
end
function c12340114.target(e,tp,eg,ep,ev,re,r,rp,chk,chkf)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c12340114.filter0,nil,e)
		local mg2=Duel.GetMatchingGroup(c12340114.filter3,tp,LOCATION_GRAVE,0,nil,e)
		mg1:Merge(mg2)
		local res=Duel.IsExistingMatchingCard(c12340114.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c12340114.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c12340114.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c12340114.filter1,nil,e)
	local mg2=Duel.GetMatchingGroup(c12340114.filter3,tp,LOCATION_GRAVE,0,nil,e)
	mg1:Merge(mg2)
	local sg1=Duel.GetMatchingGroup(c12340114.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c12340114.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
            local mat2=mat1:Filter(Card.IsLocation,nil,LOCATION_GRAVE):Filter(Card.IsRace,nil,RACE_ZOMBIE)
            mat1:Sub(mat2)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
            Duel.SendtoDeck(mat2,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat3=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat3)
		end
		tc:CompleteProcedure()
	end
end

function c12340114.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c12340114.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end