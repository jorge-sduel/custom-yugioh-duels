--Unrivaled Star-vader, Radon
function c873.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(873,0))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c873.atcon)
	e1:SetValue(300)
	c:RegisterEffect(e1)
end
function c873.filter(c)
	return c:IsFaceup() and (c:IsSetCard(0x5DC) or c:IsSetCard(0x5AA))
end
function c873.atcon(e)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL) and e:GetHandler()==Duel.GetAttacker()
	and Duel.IsExistingMatchingCard(c873.filter,c:GetControler(),LOCATION_MZONE,0,2,nil)
end