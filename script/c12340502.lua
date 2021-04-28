--Fire Core Fighter
function c12340502.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12340502,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
    e1:SetCode(EVENT_DESTROYED)
	e1:SetCountLimit(1,12340502)
	e1:SetCondition(c12340502.descon)
	e1:SetTarget(c12340502.destg)
	e1:SetOperation(c12340502.desop)
	c:RegisterEffect(e1)
	--1600 atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340502,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetHintTiming(TIMING_DAMAGE_STEP)
	e2:SetCountLimit(1,12340502+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c12340502.con)
	e2:SetTarget(c12340502.tg)
	e2:SetCost(c12340502.cost)
	e2:SetOperation(c12340502.op)
	c:RegisterEffect(e2)
end

function c12340502.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function c12340502.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c12340502.desop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

function c12340502.con(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()~=PHASE_DAMAGE or Duel.IsDamageCalculated() then return false end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return d~=nil and d:IsFaceup() and ((a:GetControler()==tp and a:IsAttribute(ATTRIBUTE_FIRE) and a:IsRelateToBattle())
		or (d:GetControler()==tp and d:IsAttribute(ATTRIBUTE_FIRE) and d:IsRelateToBattle()))
end
function c12340502.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c12340502.desfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_FIRE)
end
function c12340502.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    local exc=Group:CreateGroup()
    exc:AddCard(e:GetHandler())
    if Duel.GetAttacker():GetControler()==tp then
        exc:AddCard(Duel.GetAttacker())
    else
        exc:AddCard(Duel.GetAttackTarget())
    end
	if chk==0 then return Duel.IsExistingMatchingCard(c12340502.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,exc) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
end
function c12340502.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
    local tc
    if Duel.GetAttacker():GetControler()==tp then
        tc=Duel.GetAttacker()
    else
        tc=Duel.GetAttackTarget()
    end
    local exc=Group:CreateGroup()
    exc:AddCard(e:GetHandler())
    exc:AddCard(tc)
    
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c12340502.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,exc)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetOwnerPlayer(e:GetHandlerPlayer())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        e1:SetValue(2000)
        tc:RegisterEffect(e1)
	end
end