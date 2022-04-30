--Dark Pendulum Angel Knight
if not REVERSEPENDULUM_IMPORTED then Duel.LoadScript("proc_reverse_pendulum.lua") end
function c1447.initial_effect(c)
   RPendulum.AddProcedure(c)
c:AddSetcodesRule(1447,false,0xbb00)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE)

	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISEFFECT)

	c:RegisterEffect(e2)
	--pzone
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_LSCALE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTargetRange(LOCATION_PZONE,LOCATION_PZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_PENDULUM))
	e3:SetValue(0)
	c:RegisterEffect(e3)
	--pzone
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e4)
--Special Summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SPSUMMON_PROC)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_PZONE)
	e5:SetOperation(c1447.cost)
	c:RegisterEffect(e5)
	--attack
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_SET_BASE_ATTACK)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(c1447.atkval)
	c:RegisterEffect(e6)
	--atk
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,1))
	e7:SetCategory(CATEGORY_DAMAGE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_ATTACK_ANNOUNCE)
	e7:SetTarget(c1447.damtg)
	e7:SetOperation(c1447.damop)
	c:RegisterEffect(e7)
	--spsummon condition
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetCode(EFFECT_SPSUMMON_CONDITION)
	e8:SetValue(c1447.splimit)
	c:RegisterEffect(e8)
end
function c1447.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,Card.IsType,5,false,nil,nil,TYPE_MONSTER) end
	local g=Duel.SelectReleaseGroupCost(tp,Card.IsType,5,5,false,nil,nil,TYPE_MONSTER)
	Duel.Release(g,REASON_COST)
end
function c1447.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsFaceup(),c:GetControler(),LOCATION_EXTRA,0,nil)*1000
end
function c1447.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(4000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,4000)
end
function c1447.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c1447.splimit(e,se,sp,st)
	local sc=se:GetHandler()
	return sc:IsType(TYPE_PENDULUM)
end
