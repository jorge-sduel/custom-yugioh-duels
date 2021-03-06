--Cosmicburst Dragon
local cid,id=GetID()
cid.IsBigbang=true
if not BIGBANG_IMPORTED then Duel.LoadScript("proc_bigbang.lua") end
function cid.initial_effect(c)
c:AddSetcodesRule(id,false,0xbb109)
	c:EnableReviveLimit()
	Bigbang.AddProcedure(c,nil,2,99)
	--equip
	--local e0=Effect.CreateEffect(c)
	--e0:SetType(EFFECT_TYPE_SINGLE)
	--e0:SetCode(EFFECT_MATERIAL_CHECK)
	--e0:SetValue(cid.matcheck)
	--c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cid.con1)
	e1:SetTarget(cid.tg1)
	e1:SetOperation(cid.op1)
	c:RegisterEffect(e1)
	--tribute then equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCost(cid.cost2)
	e2:SetTarget(cid.tg2)
	e2:SetOperation(cid.op2)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cid.discon)
	e3:SetTarget(cid.distg)
	e3:SetOperation(cid.disop)
	c:RegisterEffect(e3)
	--destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetTarget(cid.reptg)
	e4:SetValue(function(e,tc) return cid.repfilter(tc,e:GetHandlerPlayer()) end)
	e4:SetOperation(cid.repop)
	c:RegisterEffect(e4)
end
function cid.ffilter(c,fc)
	return c:GetAttack()~=c:GetDefense()
end
function cid.matcheck(e,c)
	local ct=c:GetMaterial():GetClassCount(cid.ffilter)
	if ct>0 then
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cid.con1)
	e1:SetTarget(cid.tg1)
	e1:SetOperation(cid.op1)
	c:RegisterEffect(e1)
	end
end
function cid.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_BIGBANG)
end
function cid.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	local mc=e:GetHandler():GetMaterialCount()
	if chk==0 then return mc>0 and Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_GRAVE,0,1,mc,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,g:GetCount(),0,0)
end
function cid.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	local tc=sg:GetFirst()
	while tc do
		local c=e:GetHandler()
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			if not Duel.Equip(tp,tc,c,false) then return end
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(cid.eqlimit)
			tc:RegisterEffect(e1)
		end
		tc=sg:GetNext()
	end
end
function cid.eqlimit(e,c)
	return e:GetOwner()==c
end
function cid.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,aux.TRUE,1,e:GetHandler()) end
	local g=Duel.SelectReleaseGroup(tp,aux.TRUE,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function cid.eqfilter2(c)
	return c:IsLevelAbove(1) and c:IsLevelBelow(4) and not c:IsForbidden()
end
function cid.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and cid.eqfilter2(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(cid.eqfilter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,cid.eqfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function cid.op2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		if not Duel.Equip(tp,tc,c,false) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(cid.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function cid.cfilter(c,tp)
	return c:IsOnField() and c:IsControler(tp)
end
function cid.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
	local ex1,tg1,tc1=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	local ex2,tg2,tc2=Duel.GetOperationInfo(ev,CATEGORY_RELEASE)
	local ex3,tg3,tc3=Duel.GetOperationInfo(ev,CATEGORY_TOHAND)
	local ex4,tg4,tc4=Duel.GetOperationInfo(ev,CATEGORY_TODECK)
	local ex5,tg5,tc5=Duel.GetOperationInfo(ev,CATEGORY_TOEXTRA)
	local ex6,tg6,tc6=Duel.GetOperationInfo(ev,CATEGORY_TOGRAVE)
	local ex7,tg7,tc7=Duel.GetOperationInfo(ev,CATEGORY_REMOVE)
	return ((ex1 and tg1~=nil) or (ex2 and tg2~=nil) or (ex3 and tg3~=nil)
			or (ex4 and tg4~=nil) or (ex5 and tg5~=nil) or (ex6 and tg6~=nil)
			or (ex7 and tg7~=nil))
		and (tc1+tg1:FilterCount(cid.cfilter,nil,tp)-tg1:GetCount()>0
			or tc2+tg2:FilterCount(cid.cfilter,nil,tp)-tg2:GetCount()>0
			or tc3+tg3:FilterCount(cid.cfilter,nil,tp)-tg3:GetCount()>0
			or tc4+tg4:FilterCount(cid.cfilter,nil,tp)-tg4:GetCount()>0
			or tc5+tg5:FilterCount(cid.cfilter,nil,tp)-tg5:GetCount()>0
			or tc6+tg6:FilterCount(cid.cfilter,nil,tp)-tg6:GetCount()>0
			or tc7+tg7:FilterCount(cid.cfilter,nil,tp)-tg7:GetCount()>0)
end
function cid.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():GetEquipCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cid.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=e:GetHandler():GetEquipGroup():Select(tp,1,1,nil)
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Destroy(eg,REASON_EFFECT)
		end
	end
end
function cid.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsReason(REASON_BATTLE)
end
function cid.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
		and eg:IsExists(cid.repfilter,1,nil,tp) and e:GetHandler():GetEquipGroup():IsExists(Card.IsDestructable,1,nil,e) end
	if Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=e:GetHandler():GetEquipGroup():FilterSelect(tp,Card.IsDestructable,1,1,nil)
		Duel.SetTargetCard(g)
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function cid.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(g,REASON_EFFECT+REASON_REPLACE)
end
