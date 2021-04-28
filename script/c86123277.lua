--Cyber Dragon
function c86123277.initial_effect(c)
	c:EnableReviveLimit()
	--over fusion summon
	local over=Effect.CreateEffect(c)
	over:SetType(EFFECT_TYPE_FIELD)
	over:SetCode(EFFECT_SPSUMMON_PROC)
	over:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	over:SetRange(LOCATION_HAND)
	over:SetCondition(c86123277.hspcon)
	over:SetOperation(c86123277.hspop)
	c:RegisterEffect(over)
    --attack time
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetCondition(c86123277.atcon)
	e1:SetValue(c86123277.attime)
	c:RegisterEffect(e1)
end

function c86123277.hspfilter(c)
	return c:IsType(TYPE_FUSION) and aux.IsMaterialListCode(c,70095154)
end
function c86123277.hspcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(e:GetHandlerPlayer(),LOCATION_MZONE)+Duel.GetLocationCountFromEx(e:GetHandlerPlayer(),e:GetHandlerPlayer(),nil,c)>0
        and Duel.IsExistingMatchingCard(c86123277.hspfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c86123277.hspop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c86123277.hspfilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.Overlay(c,g)
    c:SetMaterial(g)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(86123277,0))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c86123277.thop)
	c:RegisterEffect(e2)
end

function c86123277.thpfilter(c)
	return c:IsFacedown() and c:IsAbleToDeck()
end
function c86123277.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c86123277.thpfilter,tp,0,LOCATION_SZONE,nil)
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end

function c86123277.atcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetMatchingGroupCount(c86123277.atfilter,e:GetHandlerPlayer(),LOCATION_GRAVE+LOCATION_REMOVED,0,nil)>1
end
function c86123277.atfilter(c)
	return c:IsFaceup() and c:IsCode(70095154)
end
function c86123277.attime(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c86123277.atfilter,e:GetHandlerPlayer(),LOCATION_GRAVE+LOCATION_REMOVED,0,nil)-1
    return ct
	--[[if ct>1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(ct-1)
		c:RegisterEffect(e1)
    end]]
end