--last draw
function c323.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c323.target)
	c:RegisterEffect(e1)
	--disable field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_BECOME_LINKED_ZONE)
	e2:SetOperation(c323.disop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_BECOME_LINKED_ZONE)
	e3:SetValue(0x17)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_BECOME_LINKED_ZONE)
	e4:SetValue(0x08)
	c:RegisterEffect(e4)
end
function c323.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)+Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)>1 end
	local dis=Duel.SelectField(tp,2,LOCATION_MZONE,LOCATION_MZONE,0)
	Duel.Hint(HINT_ZONE,tp,dis)
	e:SetLabel(dis)
end
function c323.disop(e,tp)
	return e:GetLabelObject():GetLabel()
end
