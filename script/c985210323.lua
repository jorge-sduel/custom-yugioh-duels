--Advanced Rainbow Dragon
c985210323.Is_Runic=true
if not Rune then Duel.LoadScript("proc_rune.lua") end
function c985210323.initial_effect(c)
	--Rune Summon
	c:EnableReviveLimit()
Rune.AddProcedure(c,Rune.MonFunctionEx(Card.IsSetCard,0x1034),1,1,Rune.STFunction(c985210323.STfilter),4,99)
		--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.runlimit)
	c:RegisterEffect(e1)
	--ignition summon
	--Runic.AddProcedure(c,c985210323.filter2,c985210323.filter1,2,99)
	--cannot special summon
	--local e1=Effect.CreateEffect(c)
	--e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	--e1:SetType(EFFECT_TYPE_SINGLE)
	--e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	--e1:SetValue(SUMMON_TYPE_RUNIC)
	--c:RegisterEffect(e1)
	--spsummon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c985210323.sucop)
	c:RegisterEffect(e3)
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetOperation(c985210323.atkop)
	c:RegisterEffect(e4)
	--Multiple Attack
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_EXTRA_ATTACK)
	e5:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e5:SetValue(c985210323.atkval)
	c:RegisterEffect(e5)
end
c985210323.listed_series={0x1034,0x34}
function c985210323.STfilter(c,rc,sumtype,tp)
	return c:IsSetCard(0x34,rc,sumtype,tp) and c:IsType(TYPE_SPELL)
end
function c985210323.filter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x2034)
end
function c985210323.sucop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c:GetMaterialCount()*200)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
	c:RegisterEffect(e1)
end
function c985210323.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetTargetRange(0,1)
	e5:SetValue(c985210323.aclimit)
	e5:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e5,tp)
end
function c985210323.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c985210323.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x34)
end
function c985210323.atkval(e,c)
	return Duel.GetMatchingGroupCount(c985210323.atkfilter,c:GetControler(),LOCATION_ONFIELD,0,nil)
end
