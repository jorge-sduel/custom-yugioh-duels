--究極竜騎士
function c23061993.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcCode2(c,5405694,23061998,true,true)
local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c23061993.atkval)
	c:RegisterEffect(e1)
end
function c23061993.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function c23061993.atkval(e,c)
	return Duel.GetMatchingGroupCount(c23061993.filter,e:GetHandler():GetControler(),LOCATION_GRAVE,0,nil)*-500
end
