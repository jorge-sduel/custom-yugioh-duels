--Ultimate
local s,id=GetID()
function s.initial_effect(c)
	local e1=Ritual.AddProcGreater({handler=c,filter=s.ritualfil,extrafil=s.extrafil,location=LOCATION_EXTRA})
	if not GhostBelleTable then GhostBelleTable={} end
	table.insert(GhostBelleTable,e1)
end
function s.ritualfil(c)
	return c:IsRitualMonster()
end
function s.mfilter(c)
	return not Duel.IsPlayerAffectedByEffect(c:GetControler(),69832741) and c:HasLevel() and c:IsType(TYPE_RITUAL)
		and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function s.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_GRAVE,0,nil)
end
