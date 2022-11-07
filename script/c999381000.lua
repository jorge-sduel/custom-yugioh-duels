--Greenwood Dragon
if not RUNIC_IMPORTED then Duel.LoadScript("proc_runic.lua") end
local s,id=GetID()
function s.initial_effect(c)
	--effect
	--local e1=Effect.CreateEffect(c)
	--e1:SetDescription(aux.Stringid(95492061,0))
	--e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	--e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	--e1:SetCode(EVENT_SUMMON_SUCCESS)
	--e1:SetTarget(s.tg)
	--e1:SetOperation(s.op)
	--c:RegisterEffect(e1)
	--local e2=e1:Clone()
	--e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	--c:RegisterEffect(e2)
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
	e4:SetTarget(aux.TargetBoolFunction(Card.IsRunic))
	c:RegisterEffect(e4)
	--level
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_ADD_SETCODE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_EXTRA,LOCATION_EXTRA)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SYNCHRO))
	e5:SetValue(0xsyrun)
	c:RegisterEffect(e5)
end
function s.Level(e,c)
	return c:GetRank()
end
function s.rvfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,c)
end
function s.thfilter(c,mc)
	if not c.runic_parameters or not c.Is_Runic then return false end
	local f1=c.runic_parameters[6]
	--Owns Extra Runic Parameters
	if c.ex_runic_parameters then
		local f2=c.ex_runic_parameters[6]
		return c:IsAbleToHand() and (not f1 or f1(mc) or not f2 or f2(mc))
	else return c:IsAbleToHand() and (not f1 or f1(mc)) end
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rvfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.rvfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	local mc=g:GetFirst()
	if mc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,mc)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
