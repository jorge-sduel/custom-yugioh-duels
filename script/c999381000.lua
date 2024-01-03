--Greenwood Dragon
if not Rune then Duel.LoadScript("proc_rune.lua") end
local s,id=GetID()
function s.initial_effect(c)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCost(s.cost)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--level
	--local e3=Effect.CreateEffect(c)
	--e3:SetType(EFFECT_TYPE_FIELD)
	--e3:SetCode(EFFECT_CHANGE_LEVEL)
	--e3:SetRange(LOCATION_MZONE)
	--e3:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	--e3:SetTarget(aux.TargetBoolFunction(Card.IsRunic))
	--e3:SetValue(s.Level)
	--c:RegisterEffect(e3)
	--level
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(id)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_RUNE))
	c:RegisterEffect(e4)
	--level
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(999381001)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_EXTRA,LOCATION_EXTRA)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SYNCHRO))
	--e5:SetValue(0x5sr)
	c:RegisterEffect(e5)
end
function s.rvfilter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsPublic()
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,c,tp)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.rvfilter,tp,LOCATION_HAND,0,1,nil,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local g=Duel.SelectMatchingCard(tp,s.rvfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	e:SetLabelObject(g:GetFirst())
    Duel.ConfirmCards(1-tp,g)
    Duel.ShuffleHand(tp)
end
function s.thfilter(c,mc,tp)
	return c:IsType(TYPE_RUNE) and c:IsAbleToHand()
		and mc:IsCanBeRuneMaterial(c,runc,tp)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local mc=e:GetLabelObject()
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,mc,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
