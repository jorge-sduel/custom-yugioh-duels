--クリアー・ラスト・ドラゴン
function c30000026.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x306),4,2)
	c:EnableReviveLimit()
    --remove att
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_REMOVE_ATTRIBUTE)
	e1:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e1)
    --atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c30000026.attg)
	e2:SetOperation(c30000026.atop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c30000026.attg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
    Duel.Hint(HINT_SELECTMSG,tp,562)
	local att=Duel.AnnounceAttribute(tp,1,0xffff)
    e:SetLabel(att)
end
function c30000026.atfilter(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function c30000026.atop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(c30000026.atfilter,tp,0,LOCATION_MZONE,nil,e:GetLabel())
    --attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(g:GetCount()*500)
    e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
    --negate activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
    e2:SetLabel(e:GetLabel())
	e2:SetCost(c30000026.cost)
	e2:SetOperation(c30000026.operation)
    e2:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e2,false,REGISTER_FLAG_DETACH_XMAT)
end
function c30000026.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c30000026.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
    e1:SetLabel(e:GetLabel())
	e1:SetValue(c30000026.aclimit)
	e1:SetCondition(c30000026.actcon)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c30000026.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c30000026.cfilter(c,tp,ot,att)
	return c:IsFaceup() and c:IsSetCard(0x306) and c:IsControler(tp) and ot:IsAttribute(att)
end
function c30000026.actcon(e)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
    local att=e:GetLabel()
	return (a and c30000026.cfilter(a,tp,d,att)) or (d and c30000026.cfilter(d,tp,a,att))
end