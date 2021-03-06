--Sakura, Ice Queen Slasher
function c500310066.initial_effect(c)
c500310066.Is_Evolute=true
if not EVOLUTE_IMPORTED then Duel.LoadScript("proc_evolute.lua") end
	--c:EnableCounterPermit(0x88)
	c:EnableReviveLimit()
	Evolute.AddProcedure(c,nil,2,99,c500310066.rcheck) 
   --CounterAdd
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c500310066.icop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	 --destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(500310066,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCost(c500310066.descost)
	e4:SetTarget(c500310066.destg)
	e4:SetOperation(c500310066.desop)
	c:RegisterEffect(e4)
		 --disable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetCode(EFFECT_CANNOT_ATTACK)
	e6:SetTarget(c500310066.distg)
	c:RegisterEffect(e6)

	  local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(500310066,0))
	 e7:SetCategory(CATEGORY_DAMAGE)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,500310066)
	e7:SetCost(c500310066.eqcost)
	e7:SetTarget(c500310066.target)
	e7:SetOperation(c500310066.activate)
	c:RegisterEffect(e7)
end
function c500310066.rcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WATER)
		and g:IsExists(Card.IsRace,1,nil,RACE_WARRIOR)
end
function c500310066.filter1(c,ec,tp)
	return c:IsAttribute(ATTRIBUTE_WATER) or c:IsRace(RACE_WARRIOR) 
end
function c500310066.filter2(c,ec,tp)
	return  c:IsAttribute(ATTRIBUTE_WATER) or c:IsRace(RACE_WARRIOR)  
end

function c500310066.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetAttackTarget()==nil
end
function c500310066.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
function c500310066.icop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsFaceup() and tc:IsControler(1-tp) then tc:AddCounter(0x1015,1) end
		tc=eg:GetNext()
	end
end
function c500310066.distg(e,c)
	return c:GetCounter(0x1015)>0  
end
function c500310066.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x111f,4,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x111f,4,REASON_COST)
end
function c500310066.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetTargetPlayer(1-tp)
	local dam=Duel.GetFieldGroupCount(1-tp,LOCATION_ONFIELD,0)*300
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c500310066.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local dam=Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)*100
	Duel.Damage(p,dam,REASON_EFFECT)
end
function c500310066.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x111f,2,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x111f,2,REASON_COST)
end
function c500310066.xxfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c500310066.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c500310066.xxfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c500310066.xxfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c500310066.xxfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c500310066.desop(e,tp,eg,ep,ev,re,r,rp)
   local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
