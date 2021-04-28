--クリアー・サクファイス
function c30000023.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,30000023)
	e1:SetCost(c30000023.cost)
	e1:SetTarget(c30000023.target)
	e1:SetOperation(c30000023.activate)
	c:RegisterEffect(e1)
    --spsummon
	local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e2:SetCountLimit(1,30000023)
	e2:SetTarget(c30000023.sptg)
	e2:SetOperation(c30000023.spop)
	c:RegisterEffect(e2)
end
function c30000023.trifilter(c,e,tp)
    local lv=c:GetLevel()
    local code=c:GetCode()
	return c:IsSetCard(0x306) and lv and Duel.IsExistingMatchingCard(c30000023.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,lv,code)
end
function c30000023.spfilter(c,e,tp,lv,code)
	return c:IsSetCard(0x306) and (lv==99 or c:GetLevel()<=lv) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c30000023.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c30000023.trifilter,1,nil,e,tp) end
	local g=Duel.SelectReleaseGroup(tp,c30000023.trifilter,1,1,nil,e,tp)
    e:SetLabelObject(g:GetFirst())
	Duel.Release(g,REASON_COST)
end
function c30000023.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c30000023.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local tc=e:GetLabelObject()
    local lv=tc:GetLevel()
    local code=tc:GetCode()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c30000023.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv,code)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		g:GetFirst():CompleteProcedure()
	end
end
function c30000023.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and c30000023.spfilter(chkc,e,tp,99,0) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c30000023.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp,99,0) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c30000023.spfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp,99,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c30000023.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetOperation(c30000023.desop)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		tc:RegisterEffect(e1,true)
	end
end
function c30000023.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end