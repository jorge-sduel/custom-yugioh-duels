--Planet Collapse Star-vader, Erbium
function c877.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(877,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c877.val)
	c:RegisterEffect(e1)
end
function c877.val(e,c)
	return Duel.GetMatchingGroupCount(c877.atkfilter,c:GetControler(),LOCATION_MZONE,0,e:GetHandler())*100
end
function c877.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5AA)
end