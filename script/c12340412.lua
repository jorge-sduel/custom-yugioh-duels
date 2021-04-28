--Hydra
function c12340412.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_REPTILE),6,2,c12340412.ovfilter,aux.Stringid(12340412,0))
	c:EnableReviveLimit()
	--indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetCondition(c12340412.cond)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function c12340412.ovfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_REPTILE) and c:IsType(TYPE_XYZ) and c:IsRankBelow(6) and c:GetCode()~=12340412
end

function c12340412.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_REPTILE)
end
function c12340412.nfilter(c)
	return c:IsType(TYPE_MONSTER) and c:GetRace()~=RACE_REPTILE
end
function c12340412.cond(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()>0
        and Duel.GetMatchingGroupCount(c12340412.filter,tp,LOCATION_GRAVE,0,nil)>0
        and not Duel.IsExistingMatchingCard(c12340412.nfilter,tp,LOCATION_GRAVE,0,1,nil)
end