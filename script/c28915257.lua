--Shadowflame Medium
--Design and code by Kindrindra
local ref=_G['c'..28915257]
function ref.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--[[Counter
	if not c28915257.global_check then
		c28915257.global_check=true
		c28915257[0]=0
		c28915257[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(ref.resetcount)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAINING)
		ge2:SetCondition(ref.regcon)
		ge2:SetOperation(ref.regop)
		Duel.RegisterEffect(ge2,tp)
	end
	--banish
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetTarget(ref.rmtg)
	e4:SetOperation(ref.rmop)
	c:RegisterEffect(e4)]]
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(129,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(ref.rectg)
	e2:SetOperation(ref.recop)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetCondition(ref.atkcon)
	e3:SetOperation(ref.atkop)
	c:RegisterEffect(e3)
end
function ref.atkcon(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then return false end
	if (r&REASON_EFFECT)~=0 then return rp~=tp end
-- 	return 
--e:GetHandler():IsRelateToBattle()
end
function ref.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ev)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e1)
	end
end
function ref.filter(c)
	return c:IsSetCard(0x729) and c:IsType(TYPE_SPELL)
end
function ref.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetMatchingGroupCount(ref.filter,tp,LOCATION_GRAVE,0,nil)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ct*100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,ct*100)
end
function ref.recop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c251.filter,tp,LOCATION_GRAVE,0,nil)
	Duel.Damage(1-tp,ct*100,REASON_EFFECT)
end

--[[function ref.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c28915257[2]=c28915257[Duel.GetTurnPlayer()]
	--print("Turn Player: ")
	--print(c28915257[2])
	
	c28915257[Duel.GetTurnPlayer()]=0
	c28915257[1-Duel.GetTurnPlayer()]=0
end
function ref.regcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x729) and not re:GetHandler():IsCode(28915257)
end
function ref.regop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetTurnPlayer()
	c28915257[1-p]=c28915257[1-p]+1
	--print(c28915257[1-p])
end
function ref.regop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		local p=tc:GetReasonPlayer()
		if Duel.GetTurnPlayer()~=p then
			c28915257[p]=c28915257[p]+1
		end
		tc=eg:GetNext()
	end
end
function ref.turnfilter1(c,e,tp,eg,ep,ev,re,r,rp,tid)
	local te=c:CheckActivateEffect(false,false,false)
	if c:GetTurnID()~=tid-1 or not c:IsPreviousPosition(POS_FACEUP) then return false end
	if (c:IsSpell() or c:IsTrap()) and te then
		if c:IsSetCard(0x95) then
			local tg=te:GetTarget()
			return not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)
		else
			return true
		end
	end
	return false
end
function ref.turnfilter(c,e,tp,eg,ep,ev,re,r,rp,tid)
	return c:CheckActivateEffect(false,false,false) and c:GetTurnID()~=tid-1 and (c:IsSpell() or c:IsTrap()) and c:IsPreviousPosition(POS_FACEUP)
end
function ref.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=Duel.GetMatchingGroupCount(ref.turnfilter,e:GetHandler():GetControler(),LOCATION_GRAVE,0,nil)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsAbleToRemove() end
	if chk==0 then return (ct>0) and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function ref.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end]]
