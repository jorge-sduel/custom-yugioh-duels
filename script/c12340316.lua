--Spell
function c12340316.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,12340316+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c12340316.cost)
	e1:SetTarget(c12340316.target)
	e1:SetOperation(c12340316.activate)
	c:RegisterEffect(e1)
end

function c12340316.costfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsDiscardable()
end
function c12340316.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340316.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c12340316.costfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c12340316.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c12340316.filter(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c12340316.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
    
	Duel.BreakEffect()
    if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
        and Duel.IsExistingMatchingCard(c12340316.filter,tp,LOCATION_DECK,0,1,nil) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,c12340316.filter,tp,LOCATION_DECK,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    end
    
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c12340316.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c12340316.splimit(e,c)
	return not c:IsType(TYPE_RITUAL)
end