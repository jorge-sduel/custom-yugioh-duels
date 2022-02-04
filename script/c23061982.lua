--Red-Eyes Zwei
function c23061982.initial_effect(c)
	aux.EnableDualAttribute(c)
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetCondition(aux.IsDualState)
	e1:SetValue(74677422)
	c:RegisterEffect(e1)
end