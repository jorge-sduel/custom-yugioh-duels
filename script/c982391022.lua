--Transfigure
if not Rune then Duel.LoadScript("proc_rune.lua") end
function c982391022.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	e1:SetTarget(c982391022.xyztg)
	e1:SetOperation(c982391022.xyzop)
	c:RegisterEffect(e1)
end
function c982391022.filter(c,e,tp)
	return (c.Is_Runic or c:IsType(TYPE_RUNE)) and c:IsSpecialSummonable() or (c:IsLocation(LOCATION_GRAVE) and c:IsAbleToHand())
end
function c982391022.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
 if chk==0 then return Duel.IsExistingMatchingCard(c982391022.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c982391022.xyzop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c982391022.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	   Duel.SpecialSummonRule(tp,tc,SUMMON_TYPE_RUNE)
	end
end
