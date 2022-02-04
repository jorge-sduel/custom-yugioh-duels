--Star-vader, World Line Dragon
function c876.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(876,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1)
	e1:SetCondition(c876.condition)
	e1:SetCost(c876.cost)
	e1:SetTarget(c876.target)
	e1:SetOperation(c876.activate)
	c:RegisterEffect(e1)
end
function c876.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	return not Duel.IsExistingMatchingCard(c876.confilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c876.confilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x5AA) or c:IsSetCard(0x5DC)) and (c:GetLevel()>=7 or c:GetRank()>=7)
end
function c876.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c876.cfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c876.cfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c876.cfilter(c)
	return c:IsSetCard(0x5AA) and c:IsAbleToGraveAsCost()
end
function c876.filter(c)
	return c:IsSetCard(0x5DC) and c:IsAbleToHand()
end
function c876.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 then return false end
		local g=Duel.GetDecktopGroup(tp,5)
		local result=g:FilterCount(c876.filter,nil)>0
		return result
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c876.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,5)
	local g=Duel.GetDecktopGroup(p,5)
	if g:IsExists(c876.filter,1,nil) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,c876.filter,1,1,nil)
		if sg:GetFirst():IsAbleToHand() then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-p,sg)
			Duel.ShuffleHand(p)
		else
			Duel.SendtoGrave(sg,REASON_RULE)
		end
		Duel.ShuffleDeck(p)
	else
		Duel.ShuffleDeck(p)
	end
end