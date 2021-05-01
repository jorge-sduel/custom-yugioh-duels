
--Borrel xyz link
function c224.initial_effect(c)
Xyz.AddProcedure(c,c224.xyzfilter,nil,2,nil,nil,nil,nil,false,c224.xyzcheck)
end
function c224.xyzfilter(c,xyz,sumtype,tp)
	return c:IsType(TYPE_LINK,xyz,sumtype,tp) and c:IsLink(4)
end
function c224.xyzcheck(g,tp,xyz)
	local mg=g:Filter(function(c) return not c:IsHasEffect(511001175) end,nil)
	return mg:GetClassCount(Card.GetLink)==1
end
