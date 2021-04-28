--Starve 
function c83.initial_effect(c)
		c:EnableReviveLimit()
	--fusion material	
Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_WATER),aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_WATER))
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e1)
end
