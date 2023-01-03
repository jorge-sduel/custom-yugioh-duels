--
local s,id=GetID()
function s.initial_effect(c)
	local e1=Ritual.CreateProc({handler=c,lvtype=RITPROC_GREATER,filter=s.ritualfil,location=LOCATION_HAND+LOCATION_PZONE})
end
function s.ritualfil(c)
	return c:IsType(TYPE_MONSTER+TYPE_RITUAL)
end
