--Lock the World
function c869.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c869.cost)
	c:RegisterEffect(e1)
	--Lock
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(869,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c869.zcon)
	e2:SetTarget(c869.ztg)
	e2:SetOperation(c869.zop)
	c:RegisterEffect(e2)
end
function c869.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c869.zfilter(c,tp)
	return c:IsControler(1-tp) and c:IsFacedown()
end
function c869.zcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c869.zfilter,1,nil,tp)
end
function c869.ztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)+Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 end
	local dis=Duel.SelectDisableField(tp,1,0,LOCATION_ONFIELD,0)
	e:SetLabel(dis)
end
function c869.zop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetOperation(c869.disop)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	e1:SetLabel(e:GetLabel())
	Duel.RegisterEffect(e1,tp)
end
function c869.disop(e,tp)
	return e:GetLabel()
end