--Abyss Actor
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,s.matfilter,2,99)
	--Pendulum Summon
	Pendulum.AddProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Effect Draw
		local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_BECOME_LINKED_ZONE)
	e3:SetRange(LOCATION_MZONE+LOCATION_PZONE) 
	e3:SetValue(0xffffff)
	c:RegisterEffect(e3)
	--Halve damage
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetValue(s.val)
	c:RegisterEffect(e4)
end
s.listed_series={0x10ec}
function s.matfilter(c,lc,sumtype,tp)
	return c:IsType(TYPE_PENDULUM,lc,sumtype,tp)
end
function s.val(e,re,dam,r,rp,rc)
	return math.floor(dam/2)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_DRAW_COUNT)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_DRAW)
	e1:SetValue(Duel.GetDrawCount(tp)+(5-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)))
	Duel.RegisterEffect(e1,tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
