--
local s,id=GetID()
function s.initial_effect(c)
	Fusion.RegisterSummonEff{handler=c,mincount=2}
end