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
	--negate attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetOperation(c262.negop)
	c:RegisterEffect(e3)
end
c262.listed_names={95515060}
function c262.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL)
end
function c262.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
