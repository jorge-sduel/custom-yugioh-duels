---External Worlds Lord
--Scripted by Secuter
function c12340008.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12340008,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,12340008)
	e1:SetCondition(c12340008.cond)
	c:RegisterEffect(e1)
	--cannot be battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c12340008.tg)
	c:RegisterEffect(e2)
end

function c12340008.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x201)
end
function c12340008.filter2(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK)
end
function c12340008.cond(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and	Duel.IsExistingMatchingCard(c12340008.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
		and Duel.GetMatchingGroupCount(c12340008.filter2,c:GetControler(),LOCATION_MZONE,0,nil)==0
end

function c12340008.tg(e,c)
	return c~=e:GetHandler() and c:IsFaceup() and c:IsSetCard(0x201)
end