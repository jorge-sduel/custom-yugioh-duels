--Overlay-Magic Startune Force
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.xyzfilter(c,mg)
	return c:IsXyzSummonable(nil,mg)
end
function s.Lvfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg1=Duel.GetMatchingGroup(s.Lvfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,nil)
	local mg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE+LOCATION_MZONE,0,nil,TYPE_MONSTER)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_XYZ_LEVEL)
	e2:SetTargetRange(LOCATION_MZONE+LOCATION_GRAVE,0)
	e2:SetValue(mg1:GetLevel())
	Duel.RegisterEffect(e2)
	local xyzg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if #xyzg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,xyz,nil,mg,99,99)
	end
end
