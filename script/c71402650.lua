--Mecha Drone Token
function c71402650.initial_effect(c)
	--indes
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_ADD_SETCODE)
	e9:SetValue(0x581)
	c:RegisterEffect(e9)
end