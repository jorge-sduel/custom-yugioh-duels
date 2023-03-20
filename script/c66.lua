--Red Chaos Unleashed
function c66.initial_effect(c)
	Ritual.AddProcGreater(c,c66.ritual_filter)
end
function c66.ritual_filter(c)
	return c:IsCode(19025379,70) or c:IsType(TYPE_RITUAL) and c:IsSetCard(0x3b)
end
