--Field
function c12340111.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
    --
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340111,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c12340111.adcost)
	e2:SetTarget(c12340111.adtg)
	e2:SetOperation(c12340111.adop)
	c:RegisterEffect(e2)
	--inactivatable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_INACTIVATE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetValue(c12340111.effectfilter)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_DISEFFECT)
	e5:SetRange(LOCATION_FZONE)
	e5:SetValue(c12340111.effectfilter)
	c:RegisterEffect(e5)
    --to hand
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(12340111,1))
	e6:SetCategory(LOCATION_HAND)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCondition(c12340111.gycon)
	e6:SetTarget(c12340111.gytg)
	e6:SetOperation(c12340111.gyop)
	c:RegisterEffect(e6)
end

function c12340111.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c12340111.adfilter(c,e)
	return c:IsFaceup() and c:IsAttackBelow(0) and not c:IsImmuneToEffect(e)
end
function c12340111.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340111.adfilter,tp,LOCATION_MZONE,0,1,nil,e) end
end
function c12340111.adop(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(c12340111.adfilter,tp,LOCATION_MZONE,0,nil,e)
	if sg:GetCount()>0 then
        local tc=sg:GetFirst()
        while tc do
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_SWAP_BASE_AD)
            e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e1)
            tc=sg:GetNext()
        end
	end
	--avoid battle damage
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
    e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end

function c12340111.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
    local tc=te:GetHandler()
	return p==tp and (tc:IsSetCard(0x202) or tc:IsSetCard(0x203)) and bit.band(loc,LOCATION_GRAVE)~=0
end

function c12340111.gycon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_SZONE) and c:GetPreviousSequence()==5 and c:IsPreviousPosition(POS_FACEUP)
end
function c12340111.filter(c)
	return c:IsSetCard(0x202) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() 
end
function c12340111.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340111.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c12340111.gyop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,CATEGORY_TOHAND)
	local g=Duel.SelectMatchingCard(tp,c12340111.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end