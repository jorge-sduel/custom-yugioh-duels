--Nest Hydra
function c12340409.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12340409,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
    e1:SetCountLimit(1,12340409)
	e1:SetCondition(c12340409.con)
	e1:SetOperation(c12340409.op)
	c:RegisterEffect(e1)
	--xyz atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_XMATERIAL)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(300)
	e3:SetCondition(c12340409.attcon)
	c:RegisterEffect(e3)
	--xyz negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12340409,1))
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(c12340409.discon)
	e4:SetCost(c12340409.discost)
	e4:SetTarget(c12340409.distg)
	e4:SetOperation(c12340409.disop)
	c:RegisterEffect(e4)
end

function c12340409.filter(c)
	return c:IsRace(RACE_REPTILE) and c:IsAbleToRemoveAsCost()
end
function c12340409.con(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c12340409.filter,tp,LOCATION_GRAVE,0,1,nil)
end
function c12340409.op(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c12340409.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function c12340409.attcon(e)
	return e:GetHandler():GetOriginalRace()==RACE_REPTILE
end

function c12340409.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOriginalRace()==RACE_REPTILE
		and not c:IsStatus(STATUS_BATTLE_DESTROYED) and ep==1-tp
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
		and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
		and Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):IsContains(c)
end
function c12340409.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c12340409.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c12340409.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsRelateToEffect(re) then
		Duel.SendtoGrave(eg,REASON_EFFECT)
	end
end