--Dark King Servant
function c12340302.initial_effect(c)
	c:EnableReviveLimit()
	--ritual material from grave
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_RITUAL_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
    --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340302,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,12340302)
	e2:SetCondition(c12340302.sprcon)
	e2:SetOperation(c12340302.sprop)
	c:RegisterEffect(e2)
end

function c12340302.sprfilter(c)
	return c:IsSetCard(0x205) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function c12340302.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(c12340302.sprfilter,tp,LOCATION_REMOVED,0,nil)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and rg:GetCount()>1
end
function c12340302.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c12340302.sprfilter,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SendtoDeck(g,nil,0,REASON_COST)
end