--ss rose fire
local s,id=GetID()
function s.initial_effect(c)
	c:SetSPSummonOnce(id)
	c:EnableReviveLimit()
	Link.AddProcedure(c,s.matfilter,1,1)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_RECOVER)
	e1:SetCondition(s.cd)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(13944422,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(s.rectg)
	e2:SetOperation(s.recop)
	c:RegisterEffect(e2)
end
s.listed_series={0x115}
function s.matfilter(c,scard,sumtype,tp)
	return c:IsSetCard(0x1115,scard,sumtype,tp) and not c:IsAttribute(ATTRIBUTE_FIRE,scard,sumtype,tp)
end
function s.cd(e,tp,eg,ep,ev,re,r,rp)
	return tp==ep
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,400,REASON_EFFECT)
end

function s.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_GRAVE,0,nil)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ct*100)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,ct*100)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_GRAVE,0,nil)
	Duel.Damage(tp,ct*100,REASON_EFFECT)
end