--Omicron the Magna Warrior (Anime)
function c407.initial_effect(c)
	Fusion.AddProcMix(c,true,true,39256679,11549357)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c407.splimit)
	c:RegisterEffect(e1)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c407.spcon)
	e1:SetOperation(c407.spop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(511000462,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c407.cost)
	e2:SetTarget(c407.target)
	e2:SetOperation(c407.operation)
	c:RegisterEffect(e2)
	--Take no battle damage involving this card
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCondition(c407.spcon2)
	e4:SetTarget(c407.sptg2)
	e4:SetOperation(c407.spop2)
	c:RegisterEffect(e4)
end
function c407.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c407.cfilter(c,code)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsCode(code) and c:IsAbleToGraveAsCost()
end
function c407.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c407.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil,39256679)
		and Duel.IsExistingMatchingCard(c407.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil,11549357)
end
function c407.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c407.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil,39256679)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c407.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil,11549357)
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end
function c407.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c407.spfilter(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c407.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=1
		and Duel.IsExistingTarget(c407.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,39256679)
		and Duel.IsExistingTarget(c407.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,11549357) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c407.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,39256679)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c407.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,11549357)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,2,0,0)
end
function c407.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if g:GetCount()~=2 or ft<2 then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
function c407.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_BATTLE)
		or (rp~=tp and c:IsReason(REASON_EFFECT) and c:IsPreviousControler(tp))
end
function c407.filter(c,e,tp)
	return c:IsSetCard(0x2066) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c407.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetControler()==tp and s.filter(chkc,e,tp) end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingTarget(c407.filter,tp,LOCATION_GRAVE,0,2,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c407.filter,tp,LOCATION_GRAVE,0,2,2,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,0,0)
end
function c407.spop2(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local fg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #fg>1 and Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if #fg>1 and ft==1 then fg=fg:Select(tp,1,1,nil) end
	for tc in aux.Next(fg) do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
	end
	Duel.SpecialSummonComplete()
end