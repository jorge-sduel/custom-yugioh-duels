--External Worlds Lord
--Scripted by Secuter
function c12340010.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12340010,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,12340010)
	e1:SetCondition(c12340010.cond)
	c:RegisterEffect(e1)
    --anti effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(c12340010.indtg)
	e2:SetValue(c12340010.efilter)
	c:RegisterEffect(e2)
end

function c12340010.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x201)
end
function c12340010.filter2(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c12340010.cond(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and	Duel.IsExistingMatchingCard(c12340010.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
		and Duel.GetMatchingGroupCount(c12340010.filter2,c:GetControler(),LOCATION_MZONE,0,nil)==0
end

function c12340010.indtg(e,c)
	return c:IsSetCard(0x201) and c~=e:GetHandler() and c:IsType(TYPE_MONSTER)
end
function c12340010.efilter(e,re,rp,c)
	return re:GetOwner()~=c
end