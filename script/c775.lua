--No.c69 紋章神コート・オブ・アームズ (Anime)
Duel.LoadScript("rankup_functions.lua")
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,5,4)
	--Rank Up Check
	aux.EnableCheckRankUp(c,nil,nil,2407234)
	c:EnableReviveLimit()
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTarget(function(e,c) return c~=e:GetHandler() end)
	
	e1:SetLabel(RESET_EVENT+RESETS_STANDARD)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_RANKUP_EFFECT)
	e6:SetLabelObject(e1)
	c:RegisterEffect(e6)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--immune spell
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(s.efilter)
	e4:SetLabel(RESET_EVENT+RESETS_STANDARD)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_RANKUP_EFFECT)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	--battle indestructable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e6:SetValue(function(e,c) return not c:IsSetCard(0x48) end)
	c:RegisterEffect(e6)
	--[[copy
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_BE_PRE_MATERIAL)
	e7:SetRange(LOCATION_MZONE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e7:SetOperation(s.reset)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_LEAVE_FIELD)
	e8:SetRange(LOCATION_MZONE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e8:SetOperation(s.reset)
	c:RegisterEffect(e8)]]
	--material
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(id,1))
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1)
	e9:SetTarget(s.target2)
	e9:SetOperation(s.operation2)
	c:RegisterEffect(e9)
end
s.xyz_number=69
function s.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function s.copfilter(c)
	return c:IsFaceup() and c:IsStatus(STATUS_DISABLED) and c:GetFlagEffect(id)==0
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local wg=Duel.GetMatchingGroup(s.copfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	for wbc in aux.Next(wg) do
		if c:IsFaceup() then
			local cid=c:CopyEffect(wbc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD_DISABLE,1)
			wbc:RegisterFlagEffect(id,0,0,0,cid)
		end
	end
end
function s.rfilter(c)
	return c:GetFlagEffect(id)>0
end
function s.reset(e,tp,eg,ep,ev,re,r,rp)
	local wg=eg:Filter(s.rfilter,nil)
	for wbc in aux.Next(wg) do
		e:GetHandler():ResetEffect(wbc:GetFlagEffectLabel(id),RESET_COPY)
		wbc:ResetFlagEffect(id)
	end
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function s.filter(c)
	return not c:IsType(TYPE_TOKEN) and c:IsAbleToChangeControler()
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ)
		and Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_MZONE,1,nil) end
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
	if tc and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(c,tc,true)
local cid=c:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+RESETS_STANDARD_DISABLE,1)
	--material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(tc:GetAttack())
	e3:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
	c:RegisterEffect(e3)
	end
end
