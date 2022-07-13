--Lindrack
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,s.xyzfilter,nil,2)

end
function s.xyzfilter(c,xyz,sumtype,tp)
	return (c:IsType(TYPE_LINK,xyz,sumtype,tp) and c:IsAttribute(ATTRIBUTE_LIGHT,xyz,sumtype,tp)) or (c:IsType(TYPE_XYZ,xyz,sumtype,tp) and c:IsAttribute(ATTRIBUTE_DARK,xyz,sumtype,tp))
end
