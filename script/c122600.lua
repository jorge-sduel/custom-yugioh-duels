function c122600.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c122600.spcon)
	c:RegisterEffect(e1)
	end
	function c122600.spfilter(c)
	return c:IsFaceup()
	end
function c122600.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.IsExistingMatchingCard(c122600.spfilter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end