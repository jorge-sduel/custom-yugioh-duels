--Sin Parallel Gear
function c745092800.initial_effect(c)
	--If "Sin World" is not Face-Up on the Field, Destroy this Card
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(c745092800.selfdestroycon)
	c:RegisterEffect(e1)
end
function c745092800.selfdestroycon(e)
	return not Duel.IsEnvironment(27564031)
end