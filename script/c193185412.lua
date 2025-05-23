--created by Swag, coded by Lyris
 local cid,id=GetID()
cid.IsTimeleap=true
if not TIMELEAP_IMPORTED then Duel.LoadScript("proc_timeleap.lua") end
function cid.initial_effect(c)
	c:EnableReviveLimit()
	  --synchro summon
	--time leap procedure
Timeleap.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0xd78),1,1,cid.TimeCon,nil,nil,nil,2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON)
	e1:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_TIMELEAP) end)
	e1:SetTarget(cid.sptg)
	e1:SetOperation(cid.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+100)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCategory(CATEGORY_DECKDES+CATEGORY_DISABLE)
	e2:SetCondition(cid.condition)
	e2:SetTarget(cid.target)
	e2:SetOperation(cid.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+200)
	e3:SetCondition(function(e,tp) return tp~=Duel.GetTurnPlayer() end)
	e3:SetTarget(cid.distg2)
	e3:SetOperation(cid.disop2)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(Timeleap.Future)
	e4:SetOperation(cid.spop3)
	c:RegisterEffect(e4)
end
function cid.material(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_MONSTER)
end
function cid.TimeCon(e,c)
	if c==nil then return true end
	return Duel.GetMatchingGroupCount(cid.material,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)>=5
end
function cid.sumop(e,tp,eg,ep,ev,re,r,rp,c,g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_TIMELEAP)
	aux.TimeleapHOPT(tp)
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>6 and Duel.IsPlayerCanDiscardDeck(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function cid.filter(c,e,tp)
	return c:IsSetCard(0xd78) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(tp,1) then return end
	local g=Duel.GetDecktopGroup(tp,7)
	Duel.ConfirmCards(tp,g)
	local tg,sg,tc=g:Filter(Card.IsAbleToGrave,nil)
	if #tg>0 and g:FilterCount(cid.filter,nil,e,tp)>0 then
		if Duel.SelectYesNo(tp,2) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			sg=g:FilterSelect(tp,cid.filter,1,1,nil,e,tp)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			tg:Sub(sg)
		end
		if not sg or #sg==0 or Duel.SelectYesNo(tp,1191) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			tc=tg:Select(tp,1,1,nil):GetFirst()
			if tc and tc:IsAbleToGrave() then Duel.SendtoGrave(tc,REASON_EFFECT) end
		end
		if sg and #sg>0 or tc then Duel.BreakEffect() end
	end
	Duel.ShuffleDeck(tp)
end
function cid.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainDisablable(ev)
		and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not re:GetHandler():IsStatus(STATUS_DISABLED) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function cid.cfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0xd78) and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(5)
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetCurrentChain()~=ev+1 or c:IsStatus(STATUS_BATTLE_DESTROYED) then return end
	Duel.DiscardDeck(tp,3,REASON_EFFECT)
	local ct=Duel.GetOperatedGroup():FilterCount(cid.cfilter,nil)
	if ct>0 then Duel.NegateEffect(ev) end
end
function cid.distg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
end
function cid.disop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardDeck(tp,1,REASON_EFFECT)==0 or Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)<40 then return end
	Duel.BreakEffect()
	Duel.Win(tp,0xd78)
end
function cid.disop3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Win(tp,0xd78)
end
