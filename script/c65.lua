--Earthbound Cucharasca Pacuila Golem
function c65.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	Link.AddProcedure(c,c65.matfilter,1,1)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_FZONE,LOCATION_FZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
end
function c65.matfilter(c,lc,sumtype,tp)
	return  c:GetOriginalLevel()>=8
end