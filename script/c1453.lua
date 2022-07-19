--Dark Pendulum Angel Knight
if not REVERSEPENDULUM_IMPORTED then Duel.LoadScript("proc_reverse_pendulum.lua") end
function c1453.initial_effect(c)
   RPendulum.AddProcedure(c)
c:AddSetcodesRule(1453,false,0xbb00)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE)

	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)

	c:RegisterEffect(e2)

	--Halve damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetValue(c1453.val)
	c:RegisterEffect(e3)
	--Tribute to Increase ATK
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(1453,1))
	e6:SetCategory(CATEGORY_ATKCHANGE)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetCountLimit(1)
	e6:SetCost(c1453.atkcost)
	e6:SetOperation(c1453.atkop)
	c:RegisterEffect(e6)
--Special Summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SPSUMMON_PROC)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCondition(c1453.spcon)
	e5:SetTarget(c1453.sptg)
	e5:SetOperation(c1453.spop)
	c:RegisterEffect(e5)


	--spsummon condition
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetCode(EFFECT_SPSUMMON_CONDITION)
	e8:SetValue(c1453.splimit)
	c:RegisterEffect(e8)
end
function c1453.val(e,re,dam,r,rp,rc)
	return math.floor(dam/2)
end
function c1453.dmfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c1453.spcon(e,c)
	if c==nil then return true end
	return Duel.CheckReleaseGroup(c:GetControler(),Card.IsType,5,false,5,true,c,c:GetControler(),nil,false,nil,TYPE_MONSTER)
end
function c1453.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(tp,Card.IsType,5,5,false,true,true,c,nil,nil,false,nil,TYPE_MONSTER)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
	return true
	end
	return false
end
function c1453.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end



function c1453.splimit(e,se,sp,st)
	local sc=se:GetHandler()
	return sc:IsType(TYPE_PENDULUM)
end
function c1453.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,nil,3,false,nil,e:GetHandler()) end
	local g=Duel.SelectReleaseGroupCost(tp,nil,3,3,false,nil,e:GetHandler())
	local tc=g:GetFirst()
	local suma=0
	local sumd=0
	while tc do
		suma=suma+tc:GetAttack()
		sumd=sumd+tc:GetDefense()
		tc=g:GetNext()
	end
	e:SetLabel(suma)
	--e:GetLabelObject():SetLabel(sumd)
	Duel.Release(g,REASON_COST)
end
function c1453.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(236)>0 then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	--e1:SetCondition(s.dfcon)
	e1:SetValue(e:GetLabel())
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	--local e2=Effect.CreateEffect(c)
	--e2:SetType(EFFECT_TYPE_SINGLE)
	--e2:SetCode(EFFECT_UPDATE_DEFENSE)
	--e2:SetCondition(s.dfcon)
	--e2:SetValue(e:GetLabelObject():GetLabel())
	--e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	--c:RegisterEffect(e2)
end
