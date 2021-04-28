--de-fusion
function c238.initial_effect(c)
--Activate
local e1=Effect.CreateEffect(c)
e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
e1:SetDescription(aux.Stringid(4012,8))
e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_RECOVER)
e1:SetType(EFFECT_TYPE_ACTIVATE)
e1:SetCode(EVENT_FREE_CHAIN)
e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_IGNORE_IMMUNE)
e1:SetTarget(c238.tg)
e1:SetOperation(c238.op)
c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c238.target)
	e2:SetOperation(c238.activate)
	c:RegisterEffect(e2)
end
function c238.dffilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsCode(10000010) or c:IsCode(168)
end
function c238.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c513000134.dffilter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c238.dffilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c238.dffilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetAttack())
end
function c238.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end
	local atk=tc:GetAttack()
	tc:ResetEffect(RESET_LEAVE,RESET_EVENT)
	Duel.Recover(tp,atk,REASON_EFFECT)
	tc:RegisterFlagEffect(236,RESET_EVENT+0x1fe0000,0,1)
	if Duel.GetAttacker() and Duel.GetAttacker()==tc then Duel.NegateAttack() end
	if Duel.GetCurrentChain()<=1 then return end
	for i=1,Duel.GetCurrentChain()-1 do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		local g=Duel.GetChainInfo(i,CHAININFO_TARGET_CARDS)
		if te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and g:IsContains(tc) then
			local rg=Group.CreateGroup()
			rg:Merge(g)
			rg:RemoveCard(tc)
			Duel.ChangeTargetCard(i,rg)
		end
	end
end
function c238.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsAbleToExtra()
end
function c238.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c238.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c238.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c238.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c238.mgfilter(c,e,tp,fusc,mg)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and fusc:CheckFusionMaterial(mg,c,PLAYER_NONE|FUSPROC_NOTFUSION)
end
function c238.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not (tc:IsRelateToEffect(e) and tc:IsFaceup()) then return end
	local mg=tc:GetMaterial()
	local ct=#mg
	local sumtype=tc:GetSummonType()
	if Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)~=0 and ct>0 and ct<=Duel.GetLocationCount(tp,LOCATION_MZONE)
		and mg:FilterCount(aux.NecroValleyFilter(c238.mgfilter),nil,e,tp,tc,mg)==ct
		and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.SelectYesNo(tp,aux.Stringid(238,0)) then
		Duel.BreakEffect()
		Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP)
	end
end
