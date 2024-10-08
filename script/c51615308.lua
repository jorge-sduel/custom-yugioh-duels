--created by LeonDuvall, coded by Lyris
local cid,id=GetID()
cid.IsTimeleap=true
if not TIMELEAP_IMPORTED then Duel.LoadScript("proc_timeleap.lua") end
function cid.initial_effect(c)
	c:EnableReviveLimit()
	--time leap procedure
Timeleap.AddProcedure(c,cid.matfilter,1,1,cid.timecon)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_DEFCHANGE)
	e2:SetHintTiming(TIMING_BATTLE_PHASE)
	e2:SetCondition(function() local ph=Duel.GetCurrentPhase() return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE end)
	e2:SetTarget(cid.btg)
	e2:SetOperation(cid.bop)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e4:SetValue(cid.bvalue)
	c:RegisterEffect(e4)
	--Attack while in defense position
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DEFENSE_ATTACK)
	e5:SetCondition(Timeleap.Future)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--Attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_SET_DEFENSE)
	e6:SetCondition(Timeleap.Future)
	e6:SetValue(3500)
	c:RegisterEffect(e6)
end
cid.listed_names={51615303}
cid.material={id-5}
function cid.timecon(e)
	return not Duel.IsExistingMatchingCard(cid.confilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) 
end
function cid.confilter(c)
	return c:IsFaceup() and c:IsCode(id)
end
function cid.matfilter(c)
	return c:IsCode(id-5)
end
function cid.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x1cfd) and c:IsDefenseAbove(1)
end
function cid.btg(e,tp,ev,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cid.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(cid.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cid.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function cid.bop(e,tp,ev,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_BATTLE)
		e1:SetCode(EFFECT_UPDATE_DEFENSE)
		e1:SetValue(tc:GetDefense())
		c:RegisterEffect(e1)
	end
end
function cid.bvalue(e,c)
	return c:IsFaceup() and c:IsSetCard(0xcfd) and not c:IsCode(id)
end
