--Star-vader, Astro Reaper
function c879.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(879,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(c879.con)
	e1:SetTarget(c879.tg)
	e1:SetOperation(c879.op)
	c:RegisterEffect(e1)
end
function c879.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a~=c then d=a end
	return c:IsRelateToBattle() and c:IsFaceup() and d and d:IsType(TYPE_MONSTER)
end
function c879.filter(c)
	return (c:IsSetCard(0x5AA) or c:IsSetCard(0x5DC)) and c:IsAbleToHand()
end
function c879.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 then return false end
		local g=Duel.GetDecktopGroup(tp,5)
		local result=g:FilterCount(c879.filter,nil)>0
		return result
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c879.op(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,5)
	local g=Duel.GetDecktopGroup(p,5)
	if g:IsExists(c879.filter,1,nil) then
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,c879.filter,1,1,nil)
		if sg:GetFirst():IsAbleToHand() then
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-p,sg)
			Duel.ShuffleHand(p)
		else
			Duel.SendtoGrave(sg,REASON_RULE)
		end
		local td=g:Select(tp,4,4,sg:GetFirst())
		Duel.SendtoDeck(td,nil,4,REASON_EFFECT)
	else local td=g:Select(tp,5,5,nil)
		Duel.SendtoDeck(td,nil,5,REASON_EFFECT)
	end
end