--Dimension Field
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetValue(s.indval)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e4:SetOperation(s.dop)
	c:RegisterEffect(e4)
	--decrease tribute
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SUMMON_PROC)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e5:SetCondition(s.ntcon)
	e5:SetTarget(aux.FieldSummonProcTg(s.nttg))
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_ATKCHANGE)
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTarget(s.target)
	e6:SetOperation(s.activate)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e7)
	--destroy replace/Damage when destroy
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e8:SetCode(EVENT_DESTROYED)
	e8:SetRange(LOCATION_FZONE)
	e8:SetTarget(s.damtg)
	c:RegisterEffect(e8)
end
function s.dop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttackTarget()==nil then return false end
	Duel.ChangeBattleDamage(ep,0)
end

function s.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.nttg(e,c)
	return c:IsLevelAbove(5) 
end

function s.filter(c,tp)
	return (c:GetSummonLocation()&LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA)~=0 and c:IsLocation(LOCATION_MZONE) and c:GetBaseAttack()>0 and c:IsSummonPlayer(Duel.GetTurnPlayer())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(s.filter,nil,tp)
	local ct=#g
	if chk==0 then return ct>0 end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,ct,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ttp=Duel.GetTurnPlayer()
	local g=eg:Filter(s.filter,nil,ttp):Filter(Card.IsRelateToEffect,nil,e)
	local cost=#g*500
	if #g>0 then
		if Duel.CheckLPCost(ttp,cost) and Duel.SelectYesNo(ttp,aux.Stringid(id,1)) then
			Duel.PayLPCost(ttp,cost)
	else
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
			end
		end
	end
end

function s.damfilter(c)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.damfilter,nil)
	for tc in aux.Next(g) do
		local ctl=tc:GetControler()
		if tc:IsPreviousPosition(POS_ATTACK) then
			Duel.SetLP(ctl,tc:GetPreviousAttackOnField(),REASON_RULE,true)
		elseif tc:IsPreviousPosition(POS_DEFENSE) then
			Duel.SetLP(ctl,tc:GetPreviousDefenseOnField(),REASON_RULE,true)
		end
	end
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,Duel.GetLP(tp)-e:GetLabel())
end
