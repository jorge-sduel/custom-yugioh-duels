--Reunion
function c12340324.initial_effect(c)
		c:EnableReviveLimit()
	--fusion material	
Fusion.AddProcFunRep(c,aux.FilterBoolFunction(Card.IsType,TYPE_RITUAL),3,true)
end

