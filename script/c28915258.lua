--Shadowflame Calamity
--Design and code by Kindrindra
local ref=_G['c'..28915258]
local id=28915258
ref.IsEquilibrium=true
if not EQUILIBRIUM_IMPORTED then Duel.LoadScript("proc_equilibrium.lua") end
function ref.initial_effect(c)
	c:EnableReviveLimit()
	Equilibrium.AddProcedure(c)
	Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsSetCard,0x729),ref.mat2)
	--Set from Extra
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(id,0)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCountLimit(1,id)
	e0:SetTarget(ref.settg)
	e0:SetOperation(ref.setop)
	c:RegisterEffect(e0)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCost(ref.costov)
	e1:SetCondition(ref.negcon)
	e1:SetTarget(ref.negtg)
	e1:SetOperation(ref.negop)
	c:RegisterEffect(e1)
	--Grant Effect
	----Effect to Grant
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,id+1000)
	--e2:SetCondition(ref.concon)
	e2:SetCost(ref.concost)
	e2:SetTarget(ref.contg)
	e2:SetOperation(ref.conop)
	--c:RegisterEffect(e2)
	----Grant
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetTargetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_PZONE,0)
	e3:SetTarget(ref.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--Revive
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,id)
	e4:SetTarget(ref.sstg)
	e4:SetOperation(ref.ssop)
	c:RegisterEffect(e4)
end
function ref.costov(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function ref.setmat1(c)
	return c:IsSetCard(0x729) and Duel.IsExistingMatchingCard(ref.mat2,tp,LOCATION_MZONE,0,1,c)
end
function ref.mat2(c)
	return c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4)
end
function ref.tributefilter(c,filter)
	return c:IsReleasable()
end

function ref.fusionfix(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsType(TYPE_MONSTER)
end

--Set From Extra
function ref.setcon(c,e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(ref.setmat1,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(ref.setmat1,tp,LOCATION_ONFIELD,0,1,nil)
end
function ref.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc1=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,6)
	local tc2=Duel.GetFieldCard(e:GetHandlerPlayer(),LOCATION_SZONE,7)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.mat2,tp,LOCATION_ONFIELD,0,1,nil) and e:GetHandler():CheckActivateEffect(false,false,false)~=nil and (not tc1 or not tc2) 
		and not e:GetHandler():IsStatus(STATUS_CHAINING) end
end
function ref.setop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,ref.setmat1,tp,LOCATION_ONFIELD,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,ref.mat2,tp,LOCATION_MZONE,0,1,1,g:GetFirst())
	g:Merge(g2)
	Duel.ConfirmCards(1-tp,tc)
	Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
Duel.Overlay(tc,g)
end
--Negate
function ref.ssfilter(c,tp,att)
	return c:IsSetCard(0x729) and c:IsType(TYPE_SPELL+TYPE_TRAP)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),nil,0x4107,2100,500,7,RACE_PYRO,att)
end
function ref.negcon(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and rp~=tp and g:IsExists(Card.IsControler,1,nil,tp)
		and Duel.IsChainNegatable(ev)
end
function ref.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function ref.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if Duel.IsExistingMatchingCard(ref.ssfilter,tp,LOCATION_DECK,0,1,nil,tp) and Duel.SelectYesNo(tp,aux.Stringid(28915258,3)) then
		local tc=Duel.SelectMatchingCard(tp,ref.ssfilter,tp,LOCATION_DECK,0,1,1,nil,tp,ATTRIBUTE_LIGHT):GetFirst()
		if tc then
			tc:SetStatus(STATUS_NO_LEVEL,false)
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(TYPE_NORMAL+TYPE_MONSTER)
			e1:SetReset(RESET_EVENT+0x47c0000)
			tc:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CHANGE_RACE)
			e2:SetValue(RACE_PYRO)
			tc:RegisterEffect(e2,true)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e3:SetValue(ATTRIBUTE_LIGHT)
			tc:RegisterEffect(e3,true)
			local e4=e1:Clone()
			e4:SetCode(EFFECT_SET_BASE_ATTACK)
			e4:SetValue(2100)
			tc:RegisterEffect(e4,true)
			local e5=e1:Clone()
			e5:SetCode(EFFECT_SET_BASE_DEFENSE)
			e5:SetValue(500)
			tc:RegisterEffect(e5,true)
			local e6=e1:Clone()
			e6:SetCode(EFFECT_CHANGE_LEVEL)
			e6:SetValue(7)
			tc:RegisterEffect(e6,true)
			Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end

--Grant Effect
----Grant
function ref.eftg(e,c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x729) --and c:IsType(TYPE_EFFECT)
end
----Granted Effect
function ref.concfilter(c)
	return c:IsSetCard(0x729) and c:IsAbleToRemoveAsCost()
end
function ref.concost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.concfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,ref.concfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,4))
end
function ref.contg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()~=tp and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function ref.conop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetControl(tc,tp,PHASE_END,1)~=0 then
		--[[local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fc0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)]]
	end
end

--Revive
function ref.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(ref.ssfilter,tp,LOCATION_GRAVE,0,1,nil,tp,ATTRIBUTE_DARK)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectTarget(tp,ref.ssfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp,ATTRIBUTE_DARK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,tp,LOCATION_GRAVE)
end
function ref.ssop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if tc then
		tc:SetStatus(STATUS_NO_LEVEL,false)
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_NORMAL+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x47c0000)
		tc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CHANGE_RACE)
		e2:SetValue(RACE_PYRO)
		tc:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e3:SetValue(ATTRIBUTE_DARK)
		tc:RegisterEffect(e3,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_SET_BASE_ATTACK)
		e4:SetValue(2100)
		tc:RegisterEffect(e4,true)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_SET_BASE_DEFENSE)
		e5:SetValue(500)
		tc:RegisterEffect(e5,true)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_CHANGE_LEVEL)
		e6:SetValue(7)
		tc:RegisterEffect(e6,true)
		local e7=Effect.CreateEffect(tc)
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e7:SetReset(RESET_EVENT+0x47e0000)
		e7:SetValue(LOCATION_HAND)
		tc:RegisterEffect(e7,true)
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end
