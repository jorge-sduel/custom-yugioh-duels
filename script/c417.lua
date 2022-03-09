--Sky Striker Ace - wind
local s,id=GetID()
function s.initial_effect(c)
	--Can only be special summoned once per turn
	c:SetSPSummonOnce(id)
	--Must be properly summoned before reviving
	c:EnableReviveLimit()
	--Link summon procedure
	Link.AddProcedure(c,s.matfilter,1,1)
end
s.listed_series={0x115}
function s.matfilter(c,scard,sumtype,tp)
	return c:IsSetCard(0x1115,scard,sumtype,tp) and not c:IsAttribute(ATTRIBUTE_WIND,scard,sumtype,tp)
end
