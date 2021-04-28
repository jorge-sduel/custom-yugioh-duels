--クリアー・カース・スペクター
function c30000009.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,30000021,aux.FilterBoolFunctionEx(Card.IsSetCard,0x306))
	--remove att
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_REMOVE_ATTRIBUTE)
	e1:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e1)
	--fusion summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c30000009.cost)
	e2:SetCondition(c30000009.con)
	e2:SetTarget(c30000009.tg)
	e2:SetOperation(c30000009.op)
	c:RegisterEffect(e2)
end
function c30000009.con(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c30000009.costfilter(c)
	return c:IsSetCard(0x306) and c:IsAbleToRemoveAsCost()
end
function c30000009.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c30000009.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil) end
	local lim=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if lim>3 then lim=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c30000009.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,lim,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:SetLabel(g:GetCount())
end
function c30000009.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,0)
	local eg=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,ct,ct,nil)
end
function c30000009.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local rg=tg:Filter(Card.IsRelateToEffect,nil,e)
	local att=0
	if rg:GetCount()>0 then 
		if rg:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_LIGHT) then att=att+ATTRIBUTE_LIGHT end
		if rg:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_DARK) then att=att+ATTRIBUTE_DARK end
		if rg:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_EARTH) then att=att+ATTRIBUTE_EARTH end
		if rg:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WATER) then att=att+ATTRIBUTE_WATER end
		if rg:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_FIRE) then att=att+ATTRIBUTE_FIRE end
		if rg:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WIND) then att=att+ATTRIBUTE_WIND end
		if rg:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_DEVINE) then att=att+ATTRIBUTE_DEVINE end
		--act limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(1,1)
		e1:SetValue(c30000009.aclimit)
		e1:SetLabel(att)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
		c:SetHint(CHINT_ATTRIBUTE,att)
		--destroy
		local e2=Effect.CreateEffect(c)
		e2:SetCategory(CATEGORY_DESTROY)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e2:SetCode(EVENT_DESTROYED)
		e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1)
		e2:SetCondition(c30000009.descon)
		e2:SetTarget(c30000009.destg)
		e2:SetOperation(c30000009.desop)
		e2:SetReset(RESET_EVENT+0x1ff0000)
		e2:SetLabel(att)
		c:RegisterEffect(e2)
	end
end
function c30000009.aclimit(e,re,tp)
	local att=e:GetLabel()
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsAttribute(att)
		and not re:GetHandler():IsImmuneToEffect(e) and re:GetHandler():IsLocation(LOCATION_ONFIELD)
end
function c30000009.dfilter(c,att)
	return c:IsPreviousLocation(LOCATION_MZONE) and bit.bor(c:GetPreviousAttributeOnField(),att)==att
end
function c30000009.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c30000009.dfilter,1,nil,e:GetLabel())
end
function c30000009.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e)
		and Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c30000009.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end