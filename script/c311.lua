--dejgff
function c311.initial_effect(c)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(311,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCondition(c311.negcon)
	e3:SetTarget(c311.negtg)
	e3:SetOperation(c311.negop)
	c:RegisterEffect(e3)
end
function c311.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c311.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c311.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
        local tc=eg:GetFirst()
        local seq=tc:GetSequence()
        local zone=0
        if tc:IsLocation(LOCATION_MZONE) then
            zone=0x10000
            while seq>0 do
                zone=zone*2
                seq=seq-1
            end
        elseif tc:IsLocation(LOCATION_SZONE) or tc:GetLocation()==0x0 then
            if seq<5 then--and (not tc:IsType(TYPE_PENDULUM) or not (seq==0 or seq==4)) then
                zone=0x1000000
                while seq>0 do
                    zone=zone*2
                    seq=seq-1
                end
            end
        end
        Duel.Destroy(eg,REASON_EFFECT)
        if zone>0 then
            e:SetLabel(zone)
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_FIELD)
            e1:SetCode(EFFECT_DISABLE_FIELD)
            e1:SetOperation(c311.disop)
            e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
            e1:SetLabel(e:GetLabel())
            Duel.RegisterEffect(e1,tp)
        end
	end
end
function c311.disop(e,tp)
    return e:GetLabel()
end