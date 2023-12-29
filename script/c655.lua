--
local s,id=GetID()
function s.initial_effect(c)
	local e1=Ritual.CreateProc({handler=c,lvtype=RITPROC_EQUAL,filter=s.ritualfil,extrafil=s.extrafil,extraop=s.extraop,matfilter=s.forcedgroup,location=LOCATION_REMOVED+LOCATION_DECK})
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end
s.listed_series={0xb4}
function s.ritualfil(c)
	return c:IsSetCard(0xb4)
end
function s.exfilter0(c)
	return c:IsLevelAbove(1) and c:IsAbleToGrave()
end
function s.exfilter01(c)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function s.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	if Duel.IsExistingMatchingCard(s.exfilter01,0,c:GetControler(),LOCATION_MZONE,1,nil) then
		return Duel.GetMatchingGroup(s.exfilter0,tp,LOCATION_DECK,0,nil)
	end
end
function s.extraop(mg,e,tp,eg,ep,ev,re,r,rp)
	local mat2=mg:Filter(Card.IsLocation,nil,LOCATION_DECK)
	mg:Sub(mat2)
	Duel.ReleaseRitualMaterial(mg)
	Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
end
function s.forcedgroup(c,e,tp)
	return (c:IsLocation(LOCATION_HAND+LOCATION_ONFIELD)) or (c:IsLocation(LOCATION_DECK))
end
