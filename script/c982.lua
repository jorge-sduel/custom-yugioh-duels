--synchro Acces
local s,id=GetID()
function s.initial_effect(c)
	--synchro effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.sctg)
	e1:SetOperation(s.scop)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	--Halve effect damage
	local e3=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(Cost.SelfBanish)
	e3:SetTarget(s.target2)
	e3:SetOperation(s.activate2)
	c:RegisterEffect(e3)
end
function s.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_GRAVE,0,nil)
		return Duel.IsExistingMatchingCard(s.synfilter,tp,LOCATION_EXTRA,0,1,nil,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.scop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_GRAVE,0,nil)
	local g=Duel.GetMatchingGroup(s.synfilter,tp,LOCATION_EXTRA,0,nil,nil,mg)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local sc=sg:GetFirst()
		Synchro.Send=2
		Duel.SynchroSummon(tp,sc,nil,mg)
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetOwner()
	local c=e:GetHandler()
	
	e:Reset()
end
function s.synfilter(c)
	return c:IsSynchroSummonable() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_FAIRY)
end
function s.filter(c,e,tp)
	return c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e)
		and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
	--	c:SetCardTarget(tc)
		Duel.SpecialSummonComplete()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(3)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
end
function s.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
end
function s.activate2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,id)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(s.val1)
	e1:SetReset(RESET_PHASE|PHASE_END,1)
	Duel.RegisterEffect(e1,tp)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE|PHASE_END,0,1)
	Duel.Recover(tp,2000,REASON_EFFECT)
end
function s.val1(e,re,dam,r,rp,rc)
	if r&(REASON_BATTLE|REASON_EFFECT)~=0 then
		return dam/2
	else return dam end
end
