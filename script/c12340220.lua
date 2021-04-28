--Fluid Reunion
function c12340220.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,4,2)
	c:EnableReviveLimit()
    --to deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12340220,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetCondition(c12340220.incon)
	e1:SetCost(c12340220.cost)
	e1:SetTarget(c12340220.target)
	e1:SetOperation(c12340220.operation)
	c:RegisterEffect(e1)
	--maintain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c12340220.mtcon)
	e2:SetOperation(c12340220.mtop)
	c:RegisterEffect(e2)
end
function c12340220.incon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c12340220.cfilter(c,tp,sc)
    return (c:IsFaceup() or not c:IsLocation(LOCATION_MZONE))
        and c:IsSetCard(0x204) and c:GetLevel()>0 and c:IsAbleToDeckOrExtraAsCost()
        and Duel.IsExistingMatchingCard(c12340220.tfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetLevel(),sc)
end
function c12340220.tfilter(c,lvl,sc)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsLevelBelow(lvl) and c:IsAbleToDeck() and c~=sc
end
function c12340220.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c12340220.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,c,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c12340220.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,1,c,tp,c)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	e:SetLabel(g:GetFirst():GetLevel())
end
function c12340220.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lvl=e:GetLabel()
    local c=e:GetHandler()
	if chkc then return chkc:IsFaceup() and c12340220.tfilter(chkc,lvl,c) end
	if chk==0 then return Duel.IsExistingMatchingCard(c12340220.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,c,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c12340220.tfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c,lvl,c)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c12340220.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
    end
end
function c12340220.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c12340220.mtop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) then
		e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	end
end