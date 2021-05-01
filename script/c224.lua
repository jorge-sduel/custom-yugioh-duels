
--Borrel xyz link
function c224.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	c224.xyz_filter=function(mc,ignoretoken,xyz,tp) return mc and mc:IsType(TYPE_LINK) and (not mc:IsType(TYPE_TOKEN) or ignoretoken) end
	c224.xyz_parameters={c224.xyz_filter,nil,2,nil,nil,2}
	c224.minxyzct=ct
	c224.maxxyzct=maxct
	local chk1=Effect.CreateEffect(c)
	chk1:SetType(EFFECT_TYPE_SINGLE)
	chk1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	chk1:SetCode(946)
	chk1:SetCondition(Xyz.Condition(aux.FilterBoolFunctionEx(Card.IsType,TYPE_LINK),nil,2,2))
	chk1:SetTarget(Xyz.Target(aux.FilterBoolFunctionEx(Card.IsType,TYPE_LINK),nil,2,2))
	chk1:SetOperation(c224.xyzop)
	c:RegisterEffect(chk1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetDescription(1073)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Xyz.Condition(aux.FilterBoolFunctionEx(Card.IsType,TYPE_LINK),nil,2,2))
	e1:SetTarget(Xyz.Target(aux.FilterBoolFunctionEx(Card.IsType,TYPE_LINK),nil,2,2))
	e1:SetOperation(c224.xyzop)
	e1:SetValue(SUMMON_TYPE_XYZ)
	e1:SetLabelObject(chk1)
	c:RegisterEffect(e1)
end
function c224.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local g=e:GetLabelObject()
	if not g then return end
	local remg=g:Filter(Card.IsHasEffect,nil,511002116)
	remg:ForEach(function(c) c:RegisterFlagEffect(511002115,RESET_EVENT+RESETS_STANDARD,0,0) end)
	g:Remove(Card.IsHasEffect,nil,511002116)
	g:Remove(Card.IsHasEffect,nil,511002115)
	local sg=Group.CreateGroup()
	for tc in aux.Next(g) do
		local sg1=tc:GetOverlayGroup()
		sg:Merge(sg1)
	end
	Duel.Overlay(c,sg)
	c:SetMaterial(g)
	Duel.Overlay(c,g:Filter(function(c) return c:GetEquipTarget() end,nil))
	Duel.Overlay(c,g)
	g:DeleteGroup()
end
