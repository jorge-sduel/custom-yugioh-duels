--Mysterious Water Fairy
local s,id=GetID()
if not EVOLUTE_IMPORTED then Duel.LoadScript("proc_evolute.lua") end
function s.initial_effect(c)
	c:EnableReviveLimit()
	  --synchro summon
	aux.AddOrigEvoluteType(c)
   aux.AddEvoluteProc(c,nil,8,aux.TRUE,aux.TRUE,1,99)
	   --mat check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(s.valcheck)
	c:RegisterEffect(e0)
 --destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetDescription(aux.Stringid(1600058,0))
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.condition)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
 --destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.condition2)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.cost2)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.operation2)
	e2:SetLabelObject(e0)
	c:RegisterEffect(e2)

 --destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.condition3)
	e3:SetCountLimit(1,id)
	e3:SetCost(s.cost3)
	e3:SetTarget(s.target3)
	e3:SetOperation(s.operation3)
	e3:SetLabelObject(e0)
	c:RegisterEffect(e3)

   local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetDescription(aux.Stringid(id,3))
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.condition4)
	e4:SetCountLimit(1,id)
	e4:SetCost(s.cost4)
	e4:SetTarget(s.target4)
	e4:SetOperation(s.operation4)
	e4:SetLabelObject(e0)
	c:RegisterEffect(e4)
		--atk
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(s.atkcon)
	e5:SetValue(500)
	e5:SetLabelObject(e0)
	c:RegisterEffect(e5)
	 local e6=e5:Clone()
	e6:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e6)
	
  local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetDescription(aux.Stringid(id,4))
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(s.atkcon)
	e7:SetCountLimit(1,id)
	e7:SetCost(s.cost5)
	e7:SetTarget(s.target5)
	e7:SetOperation(s.operation5)
	e7:SetLabelObject(e0)
	c:RegisterEffect(e7)
	
   --destroy
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(1600058,5))
	e8:SetCategory(CATEGORY_TODECK)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e8:SetCode(EVENT_BATTLE_START)
	e8:SetCondition(s.tdcon)
	e8:SetTarget(s.tdtg)
	e8:SetOperation(s.tdop)
	e8:SetLabelObject(e0)
	c:RegisterEffect(e8)
end
function s.valcheck(e,c)
	local g=c:GetMaterial()
	local typ=0
	local tc=g:GetFirst()
	while tc do
			typ=bit.bor(typ,tc:GetAttribute())
		tc=g:GetNext()
	end
	e:SetLabel(typ)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetLabelObject():GetLabel(),ATTRIBUTE_DARK)~=0
end
--function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
 --   if chk==0 then return e:GetHandler():IsCanRemoveEC(tp,3,REASON_COST) end
 --   e:GetHandler():IsCanRemoveEC(tp,3,REASON_COST)
--end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x88,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x88,3,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_SZONE,LOCATION_SZONE,1,c) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_SZONE,LOCATION_SZONE,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_SZONE,LOCATION_SZONE,aux.ExceptThisCard(e))
	Duel.Destroy(sg,REASON_EFFECT)
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetLabelObject():GetLabel(),ATTRIBUTE_LIGHT)~=0
end
--function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
 --   if chk==0 then return e:GetHandler():IsCanRemoveEC(tp,3,REASON_COST) end
 --   e:GetHandler():IsCanRemoveEC(tp,3,REASON_COST)
--end
function s.filter(c)
	return c:IsType(TYPE_EFFECT) and c:IsFaceup()  and c:IsDestructable()
end
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x88,2,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x88,2,REASON_COST)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c1600058.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
	local sg=Duel.GetMatchingGroup(c1600058.filter,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c1600058.filter,tp,LOCATION_MZONE,LOCATION_MZONE,aux.ExceptThisCard(e))
	Duel.Destroy(sg,REASON_EFFECT)
end

function s.condition3(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetLabelObject():GetLabel(),ATTRIBUTE_FIRE)~=0
end
--function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
 --   if chk==0 then return e:GetHandler():IsCanRemoveEC(tp,3,REASON_COST) end
 --   e:GetHandler():IsCanRemoveEC(tp,3,REASON_COST)
--end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x88,2,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x88,2,REASON_COST)
end
function s.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	  if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function s.operation3(e,tp,eg,ep,ev,re,r,rp)
	   local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

function s.condition4(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetLabelObject():GetLabel(),ATTRIBUTE_WATER)~=0
end
--function s.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
 --   if chk==0 then return e:GetHandler():IsCanRemoveEC(tp,3,REASON_COST) end
 --   e:GetHandler():IsCanRemoveEC(tp,3,REASON_COST)
--end
function s.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x88,4,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x88,4,REASON_COST)
end
function s.target4(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(aux.disfilter1,tp,0,LOCATION_ONFIELD,1,nil) end
end
function s.operation4(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	if not tc then return end
	local c=e:GetHandler()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
		end
		tc=g:GetNext()
	end
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetLabelObject():GetLabel(),ATTRIBUTE_EARTH)~=0
end

--function s.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
 --   if chk==0 then return e:GetHandler():IsCanRemoveEC(tp,3,REASON_COST) end
 --   e:GetHandler():IsCanRemoveEC(tp,3,REASON_COST)
--end
function s.spfilter(c,e,tp)
	return  c:IsSetCard(0xcf6) or (c:IsFaceup() and c:IsSetCard(0xcf6) and c:IsType(TYPE_PANDEMONIUM)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x88,4,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x88,4,REASON_COST)
end
function s.target5(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA)
end
function s.operation5(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0  then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetLabelObject():GetLabel(),ATTRIBUTE_WIND)~=0
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if chk==0 then return tc and tc:IsFaceup() and tc:IsType(TYPE_EFFCT) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tc,1,0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if tc:IsRelateToBattle() then Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)end
end
