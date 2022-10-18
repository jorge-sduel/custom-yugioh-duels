--
local s,id=GetID()
function s.initial_effect(c)
	--Fusion Material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsRace,RACE_WARRIOR),s.matfilter)
end
s.listed_names={CARD_GAIA_CHAMPION}
function s.matfilter(c,fc,sumtype,tp)
	return c:IsRace(RACE_BEAST,fc,sumtype,tp) and c:IsLevelAbove(6)
end
