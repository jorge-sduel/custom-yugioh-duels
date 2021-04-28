--Decomposition
function c12340214.initial_effect(c)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340214,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,12340214+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c12340214.target)
	e2:SetOperation(c12340214.activate)
	c:RegisterEffect(e2)
end

function c12340214.rfilter(c,e,tp)
     return c:GetLevel()>0 and c:IsSetCard(0x204) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c12340214.filter(c,e,tp)
    local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)+1
    if ct<2 then return false end
	local g=Duel.GetMatchingGroup(c12340214.rfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	return c:GetLevel()>0 and c:IsSetCard(0x204) and c:IsAbleToDeckOrExtraAsCost()
        and g:CheckWithSumEqual(Card.GetLevel,c:GetLevel(),2,ct)
end
function c12340214.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c12340214.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
    local g=Duel.SelectMatchingCard(tp,c12340214.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
    e:SetLabelObject(g)
	Duel.SetOperationInfo(g,CATEGORY_TODECK,nil,1,tp,LOCATION_MZONE)
end
function c12340214.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetLabelObject()
	local lv=tg:GetLevel()
    Duel.SendtoDeck(tg,nil,0,REASON_COST)
	local rg=Duel.GetMatchingGroup(c12340214.rfilter,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(12340214,1))
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)+1
    if ct<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=rg:SelectWithSumEqual(tp,Card.GetLevel,lv,2,ct)
	local tc=g:GetFirst()
	while tc do
        if Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP) then
            tc:RegisterFlagEffect(tc:GetCode(),RESET_EVENT+0x16e0000,0,0)
            Duel.SpecialSummonComplete()
            tc=g:GetNext()
		end
	end
end