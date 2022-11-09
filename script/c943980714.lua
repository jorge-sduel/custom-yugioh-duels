--Runic Instantation
local s,id=GetID()
if not RUNIC_IMPORTED then Duel.LoadScript("proc_runic.lua") end
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1c0)
	e1:SetTarget(s.xyztg)
	e1:SetOperation(s.xyzop)
	c:RegisterEffect(e1)
end
function s.filter(c,e,tp)
	return c.Is_Runic and c:IsSpecialSummonable()
end
function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
 if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		e:GetHandler():CancelToGrave()
	   Duel.SpecialSummonRule(tp,tc,SUMMON_TYPE_EVOLUTE,nil,e:GetHandler())
	end
end
