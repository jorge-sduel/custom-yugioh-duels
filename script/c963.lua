--昇天の黒角笛
--Black Horn of Heaven
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON)
e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
e2:SetCountLimit(1,{1,id})
	e2:SetCondition(s.condition1)
	e2:SetTarget(s.target1)
	e2:SetOperation(s.activate1)
	c:RegisterEffect(e2)
		--salvage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))

	e3:SetType(EFFECT_TYPE_IGNITION)

	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,{id,2})
	e3:SetCost(aux.bfgcost)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.activate1)

	c:RegisterEffect(e3)
end
s.listed_series={SET_QLI}
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and #eg==1 and Duel.GetCurrentChain(true)==0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
Duel.IsExistingMatchingCard(s.negfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,eg:GetAttack(),eg:GetLevel())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,#eg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,#eg,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp,chk)
		local g=Duel.GetMatchingGroup(s.negfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp,eg:GetAttack(),eg:GetLevel())
		if #g>0 then
		local sg=g:Select(tp,1,1,nil)
		local sc=sg:GetFirst()
		Duel.Remove(sc,POS_FACEUP,REASON_EFFECT)
	Duel.NegateSummon(eg)
		Duel.SendtoDeck(eg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return re and Duel.IsChainNegatable(ev)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
Duel.IsExistingMatchingCard(s.negfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,eg:GetAttack(),eg:GetLevel())
	end
end
function s.activate1(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(s.negfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp,eg:GetAttack(),eg:GetLevel())
		if #g>0 then
		local sg=g:Select(tp,1,1,nil)
		local sc=sg:GetFirst()
		Duel.Remove(sc,POS_FACEUP,REASON_EFFECT)
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then 	Duel.SendtoDeck(eg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
  end
	end
end
function s.negfilter(c,e,tp,atk,lv)
	return c:IsSetCard(SET_QLI) and (c:GetAttack()>ATK or c:GetLevel()>lv) 
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(SET_QLI) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.activate2(e,tp,eg,ep,ev,re,r,rp)
	local ft=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),2)
	if ft>0 then
		if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
		local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK,0,nil,e,tp)
		if #g>0 then
			local sg=aux.SelectUnselectGroup(g,e,tp,1,ft,aux.dncheck,1,tp,HINTMSG_SPSUMMON)
			if #sg==0 then return end
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		--Cannot Special Summon from the Extra Deck
				local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetReset(RESET_PHASE|PHASE_END)
		e1:SetTargetRange(1,0)
		e1:SetTarget(s.splimit)
		Duel.RegisterEffect(e1,tp)
	end
end
