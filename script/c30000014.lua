--クリアー・シンセシズ
function c30000014.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,30000014+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(TIMING_BATTLE_START,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e1:SetCondition(c30000014.spcon)
	e1:SetTarget(c30000014.target)
	e1:SetOperation(c30000014.activate)
	c:RegisterEffect(e1)
end
function c30000014.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_BATTLE or ph==PHASE_MAIN2
end
function c30000014.cfilter(c)
	return c:IsSetCard(0x306) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c30000014.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x306)
end
function c30000014.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c30000014.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c30000014.cfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingTarget(c30000014.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c30000014.cfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local nm=g:GetFirst():GetCode()
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(nm)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g2=Duel.SelectTarget(tp,c30000014.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c30000014.filter1(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c30000014.filter2(c,e,tp,m,ec,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x306) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,ec,chkf)
end
function c30000014.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local nm=e:GetLabel()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(nm)
		tc:RegisterEffect(e1)
		local ec=tc
		if ec:IsControler(1-tp) or ec:IsImmuneToEffect(e) then return end
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetMatchingGroup(c30000014.filter1,tp,LOCATION_HAND+LOCATION_MZONE,0,ec,e)
		local sg1=Duel.GetMatchingGroup(c30000014.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,ec,nil,chkf)
		local mg2=nil
		local sg2=nil
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			mg2=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			sg2=Duel.GetMatchingGroup(c30000014.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,ec,mf,chkf)
		end
		if (sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0)) and Duel.SelectYesNo(tp,aux.Stringid(30000014,0)) then
			Duel.BreakEffect()
			local sg=sg1:Clone()
			if sg2 then sg:Merge(sg2) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=sg:Select(tp,1,1,nil)
			local tc=tg:GetFirst()
			if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
				local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,ec,chkf)
				tc:SetMaterial(mat1)
				Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			else
				local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,ec,chkf)
				local fop=ce:GetOperation()
				fop(ce,e,tp,tc,mat2)
			end
			tc:CompleteProcedure()
		else
			local cg1=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_MZONE,0)
			local cg2=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
			if cg1:GetCount()>1 and cg2:IsExists(Card.IsFacedown,1,nil)
				and Duel.IsPlayerCanSpecialSummon(tp) and not Duel.IsPlayerAffectedByEffect(tp,27581098) then
				Duel.ConfirmCards(1-tp,cg1)
				Duel.ConfirmCards(1-tp,cg2)
				Duel.ShuffleHand(tp)
			end
		end
	end		
end