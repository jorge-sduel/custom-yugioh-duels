--Lost Runic Circle
function c948930275.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c948930275.target)
	e1:SetOperation(c948930275.activate)
	c:RegisterEffect(e1)
end
function c948930275.filter(c,e,tp)
	return c:IsType(TYPE_RUNE) and c:IsLevelBelow(6)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RUNE,tp,false,true)
end
function c948930275.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c948930275.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c948930275.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c948930275.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	local mg=Group.FromCards(e:GetHandler())
	tc:SetMaterial(mg)
	if Duel.SpecialSummon(tc,SUMMON_TYPE_RUNE,tp,tp,false,true,POS_FACEUP)~=0 then
		local fid=e:GetHandler():GetFieldID()
		tc:CompleteProcedure()
		tc:RegisterFlagEffect(948930275,RESET_EVENT+0x1fe0000,0,1,fid)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetLabelObject(tc)
		e2:SetCondition(c948930275.descon)
		e2:SetOperation(c948930275.desop)
		Duel.RegisterEffect(e2,tp)
	end
	mg:DeleteGroup()
end
function c948930275.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(948930275)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c948930275.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
