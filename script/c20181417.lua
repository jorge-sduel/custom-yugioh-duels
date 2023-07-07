-- Terradication Tormentor, Calamitybringer HADES
-- Created and scripted by Swaggy
local cid,id=GetID()
cid.IsTimeleap=true
if not TIMELEAP_IMPORTED then Duel.LoadScript("proc_timeleap.lua") end
function cid.initial_effect(c)
	c:EnableReviveLimit()
	  --synchro summon
	--time leap procedure
Timeleap.AddProcedure(c,cid.tlfilter,1,1,cid.TimeCon)
	--time leap procedure
	--Toadally Gaiaemperor.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(20181407)
	c:RegisterEffect(e1)
	--Is This Ivory?
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,20181417)
	e2:SetCondition(cid.actcon)
	e2:SetTarget(cid.patg)
	e2:SetOperation(cid.paop)
	c:RegisterEffect(e2) 
	--[[ GAUNTLET HA-DUMBASS!
		local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_BATTLED)
	e3:SetCountLimit(1,20181417+1000)
	e3:SetCondition(cid.bdogcon)
	e3:SetTarget(cid.damtg)
	e3:SetOperation(cid.damop)
	c:RegisterEffect(e3)]]
	--Burn
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	--e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetRange(LOCATION_MZONE)
	--e3:SetCountLimit(1)
	e3:SetCondition(cid.bcon)
	e3:SetTarget(cid.btg)
	e3:SetOperation(cid.bop)
	c:RegisterEffect(e3)
end
function cid.TimeCon(e,c)
	if c==nil then return true end
	return Duel.GetMatchingGroupCount(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,0x9b5)>4
end
function cid.sumcon(e,c)
if c==nil then return true end
return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
	Duel.GetMatchingGroupCount(cid.terfilter,c:GetControler(),LOCATION_GRAVE,0,nil,0x9b5)>=5
end
function cid.terfilter(c)
	return c:IsSetCard(0x9b5)
end
function cid.tlfilter(c,e,mg)
	return c:IsCode(20181407)
end
function cid.actfilter(c,tp)
	return c:GetType()&TYPE_PENDULUM==TYPE_PENDULUM and Duel.GetLocationCount(tp,LOCATION_PZONE)>0 and c:IsSetCard(0x9b5) and (c:IsLocation(LOCATION_GRAVE) or (c:IsLocation(LOCATION_HAND) or (c:IsLocation(LOCATION_GRAVE) or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup()))))
		and not c:IsForbidden() and not Duel.IsExistingMatchingCard(cid.excfilter,tp,LOCATION_SZONE,0,1,c)
end
function cid.excfilter(c)
	return c:GetType()&TYPE_PENDULUM==TYPE_PENDULUM and c:IsFaceup()
end
function cid.actcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_TIMELEAP)
end
--[[function cid.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.actfilter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,nil,tp) end
end
function cid.actop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cid.actfilter),tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.HintSelection(g)
		Card.SetCardData(tc,CARDDATA_TYPE,TYPE_TRAP+TYPE_CONTINUOUS)
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		if not tc:IsLocation(LOCATION_SZONE) then
			local edcheck=0
			if tc:IsLocation(LOCATION_EXTRA) then edcheck=TYPE_PENDULUM end
			Card.SetCardData(tc,CARDDATA_TYPE,TYPE_MONSTER+TYPE_EFFECT+edcheck+aux.GetOriginalPandemoniumType(tc))
		else
			tc:RegisterFlagEffect(726,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CANNOT_DISABLE,1)
			tc:RegisterFlagEffect(725,RESET_PHASE+PHASE_END,EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE,1)
		end
	end
end]]
function cid.dmgfilter(c,tp)
return c:GetType()&TYPE_PENDULUM==TYPE_PENDULUM and c:IsFaceup() and c:IsSetCard(0x9b5)
end
function cid.bdogcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return false end
	if d:IsControler(tp) then a,d=d,a end
	return (a:IsType(TYPE_PENDULUM) and a:IsSetCard(0x9b5)) and d:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cid.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetHandler():GetBattleTarget()
	--Duel.SetTargetCard(bc)
	local dam=bc:GetBaseAttack()
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function cid.damop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		--local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local dam=tc:GetBaseAttack()
		if dam<0 then dam=0 end
		Duel.Damage(1-tp,dam,REASON_EFFECT)
	end
end
function cid.bcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	return rc:IsRelateToBattle() and rc:IsStatus(STATUS_OPPO_BATTLE)
		and rc:IsFaceup() and rc:IsControler(tp) and rc:IsSetCard(0x9b5) and rc:IsType(TYPE_PENDULUM)
end
function cid.btg(e,tp,eg,ep,ev,re,r,rp,chk)
	local atk=eg:GetFirst():GetBattleTarget():GetAttack()
	if chk==0 then return atk>0 end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	--Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,atk,1-tp,0)
end
function cid.bop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Damage(1-tp,eg:GetFirst():GetBattleTarget():GetAttack(),REASON_EFFECT)
end
function cid.patg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckPendulumZones(tp)
		and Duel.IsExistingMatchingCard(cid.pcfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
end
function cid.paop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.CheckPendulumZones(tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cid.pcfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	if #g>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function cid.pcfilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
