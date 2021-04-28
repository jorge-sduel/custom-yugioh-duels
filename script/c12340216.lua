--Tempest
function c12340216.initial_effect(c)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12340216,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c12340216.con)
	e1:SetOperation(c12340216.op)
	c:RegisterEffect(e1,false,1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c12340216.handcon)
	c:RegisterEffect(e2)
end

function c12340216.filter(c,tp)
	return  c:IsSetCard(0x204) and c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function c12340216.con(e,tp,eg,ep,ev,re,r,rp)
	--if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	--local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	--return tg and tg:GetCount()==1 and tg:IsExists(c12340216.tfilter,1,nil,tp) and Duel.IsChainNegatable(ev)
	if rp==tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c12340216.filter,1,nil,tp)
		and Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c12340216.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c12340216.etarget)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	Duel.RegisterEffect(e2,tp)
end
function c12340216.etarget(e,c)
	return c:IsFaceup() and c:IsSetCard(0x204)
end

function c12340216.handfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x204)
end
function c12340216.handcon(e)
	return not Duel.IsExistingMatchingCard(c12340216.handfilter,tp,LOCATION_MZONE,0,1,nil)
end