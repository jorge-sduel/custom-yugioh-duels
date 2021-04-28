--Upgrade
function c12340213.initial_effect(c)
	--Level Up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12340213,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,12340213+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c12340213.uptarget)
	e1:SetOperation(c12340213.upactivate)
	c:RegisterEffect(e1)
	--Union
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340213,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,12340213+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c12340213.target)
	e2:SetOperation(c12340213.activate)
	c:RegisterEffect(e2)
end

function c12340213.filter(c,g,e,tp)
	return c:GetLevel()>0 and c:IsSetCard(0x204) and g:CheckWithSumEqual(Card.GetLevel,c:GetLevel(),2,99) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c12340213.rfilter(c)
	return c:GetLevel()>0 and c:IsSetCard(0x204) and c:IsAbleToDeckAsCost()
end
function c12340213.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local rg=Duel.GetMatchingGroup(c12340213.rfilter,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(c12340213.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,rg,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_MZONE)
end
function c12340213.activate(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetMatchingGroup(c12340213.rfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(12340213,1))
	local g=Duel.SelectMatchingCard(tp,c12340213.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,rg,e,tp):GetFirst()
	if g then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=rg:SelectWithSumEqual(tp,Card.GetLevel,g:GetLevel(),2,99)
        Duel.SendtoDeck(sg,nil,0,REASON_COST)
        
        if g and Duel.SpecialSummonStep(g,0,tp,tp,true,true,POS_FACEUP) then
            g:RegisterFlagEffect(g:GetCode(),RESET_EVENT+0x16e0000,0,0)
            Duel.SpecialSummonComplete()
		end
	end
end

function c12340213.shfilter(c,e,tp)
	return c:GetLevel()>0 and c:IsSetCard(0x204) and c:IsAbleToDeckAsCost()
end
function c12340213.upfilter(c,e,tp,lv)
	return c:IsSetCard(0x204) and c:GetLevel()==lv+2 and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c12340213.uptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c12340213.shfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
    local g=Duel.SelectMatchingCard(tp,c12340213.shfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	Duel.SendtoDeck(g,nil,0,REASON_COST)
    e:SetLabelObject(g)
end
function c12340213.upactivate(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetLabelObject()
	local lv=tg:GetLevel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c12340213.upfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp,lv):GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP) then
		--Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		tc:RegisterFlagEffect(tc:GetCode(),RESET_EVENT+0x16e0000,0,0)
        Duel.SpecialSummonComplete()
		tc:CompleteProcedure()
	end
end