--
local s,id=GetID()
function s.initial_effect(c)
	local e1=Ritual.AddProcGreater({handler=c,filter=s.ritualfil,location=LOCATION_HAND|LOCATION_PZONE})
end
function s.ritualfil(c)
	return c:IsRitualMonster()
end
