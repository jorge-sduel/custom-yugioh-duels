--Starve 
function c84.initial_effect(c)
		c:EnableReviveLimit()
	--fusion material	
Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_EARTH),aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_EARTH))
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c84.ffilter(c)
	return c:IsFusionAttribute(ATTRIBUTE_EARTH)
	end
