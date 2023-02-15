--Red Dragon
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	--Synchro.AddProcedure(c,nil,1,1,aux.FilterBoolFunction(Card.IsCode,70902743),1,1)
	Synchro.AddProcedure(c,nil,1,1,Synchro.Nontuner(nil),1,1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)
	--indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(s.indval)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,id)
	e4:SetCondition(s.thcon)
	e4:SetTarget(s.lptg)
	e4:SetOperation(s.lpop)
	c:RegisterEffect(e4)
	--double tuner
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(21142671)
	c:RegisterEffect(e6)
end
s.material={70902743}
s.listed_names={70902743}
s.synchro_nt_required=1
function s.atkval(e,c)
	return (Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),LOCATION_GRAVE,0,nil,TYPE_SYNCHRO)+Duel.GetMatchingGroupCount(Card.IsType,c:GetControler(),LOCATION_GRAVE,0,nil,TYPE_TUNER))*1000
end
function s.indval(e,re,tp)
	return e:GetHandler():GetControler()~=tp
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(1-tp)>1 end
	Duel.SetTargetPlayer(1-tp)
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.SetLP(p,1)
end
