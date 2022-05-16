--Tool Gear
function c101600108.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101600108,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c101600108.tg)
	e1:SetOperation(c101600108.op)
	e1:SetCountLimit(1,101600108)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	c:RegisterEffect(e2)
	--synchro custom
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c101600108.sctg)
	e4:SetValue(1)
	e4:SetOperation(c101600108.scop)
	c:RegisterEffect(e4)
end
function c101600108.filter(c)
	return c:IsLevelBelow(4) and c:IsAbleToHand() and not c:IsCode(101600108)
end
function c101600108.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101600108.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101600108.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101600108.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101600108.scfilter1(c,tp,mc)
	return Duel.IsExistingMatchingCard(c101600108.scfilter2,tp,LOCATION_GRAVE,0,1,nil,mc,c,tp)
end
function c101600108.scfilter2(c,mc,sc,tp)
	local mg=Group.FromCards(c,mc)
	return c:IsCanBeSynchroMaterial(sc) and sc:IsSynchroSummonable(nil,mg)
		and Duel.GetLocationCountFromEx(tp,tp,mg,sc)>0
end
function c101600108.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c101600108.scfilter1,tp,LOCATION_EXTRA,0,1,nil,tp,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101600108.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c101600108.scfilter1,tp,LOCATION_EXTRA,0,nil,tp,c)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local sc=g:Select(tp,1,1,nil):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local mg=Duel.SelectMatchingCard(tp,c101600108.scfilter2,tp,LOCATION_GRAVE,0,1,1,nil,c,sc,tp)
		mg:AddCard(c)
Duel.SendtoDeck(mg,nil,REASON_EFFECT)
		Duel.SynchroSummon(tp,sc,nil,mg)
	end
end
