--Field
function c12340211.initial_effect(c)
	c:EnableCounterPermit(0x51)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Add counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340211,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(c12340211.accon)
	e2:SetOperation(c12340211.acop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x204))
	e3:SetValue(c12340211.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--Destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTarget(c12340211.desreptg)
	e5:SetOperation(c12340211.desrepop)
	c:RegisterEffect(e5)
end

function c12340211.atkval(e,c)
	return e:GetHandler():GetCounter(0x51)*100
end

function c12340211.cfilter(c,tp)
	return c:IsSetCard(0x204) and c:IsPreviousLocation(LOCATION_DECK)
		and c:GetPreviousControler()==tp
end
function c12340211.accon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c12340211.cfilter,1,nil,tp)
end
function c12340211.acop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x51,1)
end

function c12340211.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_RULE)
		and e:GetHandler():GetCounter(0x51)>1 end
	return Duel.SelectYesNo(tp,aux.Stringid(12340211,1))
end
function c12340211.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0x51,2,REASON_EFFECT)
end