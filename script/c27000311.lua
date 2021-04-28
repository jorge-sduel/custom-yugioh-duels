---CCG: Defensive Spirit Art - Kekkai
function c27000311.initial_effect(c)
	--Activate(effect)
	local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e1:SetType(EFFECT_TYPE_ACTIVATE)
		e1:SetCode(EVENT_CHAINING)
		e1:SetCondition(c27000311.NEGCond)
		e1:SetCost(c27000311.NEGCost)
		e1:SetTarget(c27000311.NEGTarg)
		e1:SetOperation(c27000311.NEGAct)
	c:RegisterEffect(e1)
	--Activate(summon)
	local e2=Effect.CreateEffect(c)
		e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
		e2:SetType(EFFECT_TYPE_ACTIVATE)
		e2:SetCode(EVENT_SUMMON)
		e2:SetCondition(c27000311.SPNCon)
		e2:SetCost(c27000311.SPNCost)
		e2:SetTarget(c27000311.SPNTarg)
		e2:SetOperation(c27000311.SPNAct)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
		e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
end
function c27000311.NEGCond(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c27000311.NEGFilter(c)
	return c:IsFaceup() 
		and c:IsSetCard(0xbf) 
		and c:IsCanTurnSet()
end
function c27000311.NEGCost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c27000311.NEGFilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c27000311.NEGFilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE,REASON_COST)
end
function c27000311.NEGTarg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	-- if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c27000311.NEGFilter(chkc) end
	-- if chk==0 then return Duel.IsExistingTarget(c27000311.NEGFilter,tp,LOCATION_MZONE,0,1,nil) end
	-- Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	-- Duel.SelectTarget(tp,c27000311.NEGFilter,tp,LOCATION_MZONE,0,1,1,nil)
	-- Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	-- if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		-- Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	-- end
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c27000311.NEGAct(e,tp,eg,ep,ev,re,r,rp)
	-- local tc=Duel.GetFirstTarget()
	-- if tc:IsFaceup() and tc:IsRelateToEffect(e) and Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)~=0 then
		-- Duel.BreakEffect()
		-- if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
			-- Duel.Destroy(eg,REASON_EFFECT)
		-- end
	-- end
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end	
end
function c27000311.SPNCon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 
		and eg:IsExists(Card.IsControler,1,nil,1-tp)
end
-- function c27000311.SPNCFilter(c)
	-- return c:IsSetCard(0xc0) 
		-- and c:IsType(TYPE_MONSTER) 
		-- and c:IsAbleToTributeAsCost()
-- end
function c27000311.SPNCFilter(c,tp)
	return c:IsFaceup() 
		and c:IsSetCard(0xc0) 
		and c:IsControler(tp)
end
function c27000311.SPNCost(e,tp,eg,ep,ev,re,r,rp,chk)
	--if chk==0 then return Duel.IsExistingMatchingCard(c27000311.SPNCFilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil) end
	--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	--local g=Duel.SelectMatchingCard(tp,c27000311.SPNCFilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
	--Duel.SendtoGrave(g,REASON_COST)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c27000311.SPNCFilter,1,nil,tp) end
	local sg=Duel.SelectReleaseGroup(tp,c27000311.SPNCFilter,1,1,nil,tp)
	Duel.Release(sg,REASON_COST)
end
function c27000311.SPNTarg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(Card.IsControler,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c27000311.SPNAct(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=eg:Filter(Card.IsControler,nil,1-tp)
	Duel.NegateSummon(g)
	Duel.Destroy(g,REASON_EFFECT)
end