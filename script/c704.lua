--
local s,id=GetID()
function s.initial_effect(c)
	--Special Summon 1 Dinosaur monster from your hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e2:SetCost(aux.bfgcost)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(s.target2)
	e2:SetOperation(s.activate2)
	c:RegisterEffect(e2)
end
function s.cfilter(c)
	return c.Is_Cosmic and c:IsMonster() and c:IsAbleToRemoveAsCost() and aux.SpElimFilter(c,true)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function s.rescon(sg,e,tp,mg)
	return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil,e,tp,#sg)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return aux.SelectUnselectGroup(cg,e,tp,nil,nil,s.rescon,0)
	end
	local rg=aux.SelectUnselectGroup(cg,e,tp,nil,nil,s.rescon,1,tp,HINTMSG_REMOVE,s.rescon)
	Duel.SetTargetParam(#rg)
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local lv=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if lv<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,lv,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
function s.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and c.Is_Cosmic
end
function s.filter2(c)
	return c:IsFaceup()
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.filter2,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
	tc:AddCounter(0x1112c,1)
		local g=Duel.GetMatchingGroup(s.filter2,tp,0,LOCATION_MZONE,tc)
		local lc=g:GetFirst()
		for lc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-600)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			lc:RegisterEffect(e1)
		end
	end
end
