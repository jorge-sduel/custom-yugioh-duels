--
--Automate ID
local scard,s_id=GetID()
function scard.initial_effect(c)
	--code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CHANGE_CODE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(0xff)
	e0:SetValue(80280737)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(scard.cost)
	e1:SetTarget(scard.target)
	e1:SetOperation(scard.activate)
	c:RegisterEffect(e1)
end
scard.list={[44508094]=61257789,[70902743]=77336644,[6021033]=1764972,
				[31924889]=14553285,[23693634]=38898779,[95526884]=37169670}
function scard.cost(e,tp,eg,ep,ev,re,r,rp,chk)
		e:SetLabel(1)
	return true
end
function scard.filter1(c,e,tp,ft)
return c:IsType(TYPE_SYNCHRO) and (ft>0 or (c:GetSequence()<5 and c:IsControler(tp))) 
		and Duel.IsExistingMatchingCard(scard.filter2,tp,LOCATION_DECK,0,1,nil,c:GetCode(),e,tp)
end
function scard.filter2(c,tcode,e,tp)
		return c:IsSetCard(0x104f) and c.assault_mode and c.assault_mode==tcode and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function scard.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return ft>-1 and Duel.CheckReleaseGroupCost(tp,scard.filter1,1,false,nil,nil,e,tp,ft)
	end
	local rg=Duel.SelectReleaseGroupCost(tp,scard.filter1,1,1,false,nil,nil,e,tp,ft)
	Duel.SetTargetParam(rg:GetFirst():GetCode())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE)
end
function scard.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local code=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,scard.filter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,code,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP_ATTACK)>0 then
		tc:CompleteProcedure()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetTargetRange(1,0)
		Duel.RegisterEffect(e1,tp)
	end
end
