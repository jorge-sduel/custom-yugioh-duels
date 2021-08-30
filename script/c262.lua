--guard kay'st
function c262.initial_effect(c)
	--immune spell
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c262.efilter)
	c:RegisterEffect(e1)
	--battle target
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetValue(aux.imval2)
	c:RegisterEffect(e5)
end
c262.listed_names={95515060}
function c262.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL)
end
function c262.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
