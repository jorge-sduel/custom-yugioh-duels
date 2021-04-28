--fus pen
function c102.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,c102.ffilter,1,63,true)
end
function c102.ffilter(c,fc)
	return c:IsType(TYPE_MONSTER)
end