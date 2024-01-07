--
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--synchro summon
	Synchro.AddProcedure(c,s.tfilter,1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetOperation(s.drop)
	c:RegisterEffect(e1)
		--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetValue(SUMMON_TYPE_SYNCHRO+82)
	e2:SetCondition(s.sprcon)
	e2:SetOperation(s.sprop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
s.material={83295594}
s.listed_names={83295594}
s.material_setcode=0x1017
function s.tfilter(c,lc,stype,tp)
	return c:IsSummonCode(lc,stype,tp,83295594) or c:IsHasEffect(20932152)
end
function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-e:GetHandlerPlayer()
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_HAND+LOCATION_MZONE,0,c)
	if #tg>0 and Duel.SelectEffectYesNo(tp,c) then
		Duel.Hint(HINT_CARD,0,id)
		for tc in aux.Next(tg) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetCode(EFFECT_SYNCHRO_MAT_FROM_HAND)
	e1:SetCountLimit(1,id)
			e1:SetValue(s.synval)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END)
			tc:RegisterEffect(e1)
	Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
	Duel.Readjust()
end
function s.synval(e,mc,sc) --this effect, this card and the monster to be summoned
	return not sc~=e:GetHandler()
end
function s.sincronfilter(c)
	return c:IsSetCard(0x1017) and c:IsAbleToDeck()
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		local g=Duel.SelectMatchingCard(tp,s.sincronfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetReset(RESET_EVENT|RESETS_STANDARD)
	e4:SetValue(300)
	c:RegisterEffect(e4)
end
function s.sfilter(c,tp,sc)
	local rg=Duel.GetMatchingGroup(s.pfilter,tp,LOCATION_MZONE,0,c)
	return c:IsCode(83295594) and c:IsReleasable() and c:IsLevelBelow(2147483647)
		and rg:IsExists(s.filterchk,1,nil,rg,Group.CreateGroup(),tp,c,sc)
end
function s.pfilter(c)
	return c:IsLevelBelow(2147483647) and (not c:IsType(TYPE_TUNER)) and c:IsReleasable()
end
function s.filterchk(c,g,sg,tp,sync,sc)
	sg:AddCard(c)
	sg:AddCard(sync)
	local res=Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0 
		and sg:CheckWithSumEqual(Card.GetLevel,7,#sg,#sg)
	sg:RemoveCard(sync)
	if not res then
		res=g:IsExists(s.filterchk,1,sg,g,sg,tp,sync,sc)
	end
	sg:RemoveCard(c)
	return res
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,1,nil,tp,c) and Duel.GetTurnPlayer()==1-tp
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,s.sfilter,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,1,1,nil,tp,c)
	local sync=g:GetFirst()
	local rg=Duel.GetMatchingGroup(s.pfilter,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,sync)
	local tc
	local mg=Group.CreateGroup()
	while true do
		local tg=rg:Filter(s.filterchk,mg,rg,mg,tp,sync,c)
		if #tg<=0 then break end
		mg:AddCard(sync)
		local cancel=#mg>1 and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0 
			and mg:CheckWithSumEqual(Card.GetLevel,7,#mg,#mg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		tc=Group.SelectUnselect(tg,mg,tp,cancel,cancel)
		if not tc then break end
		mg:RemoveCard(sync)
		if tc~=sync then
			if mg:IsContains(tc) then
				mg:RemoveCard(tc)
			else
				mg:AddCard(tc)
			end
		end
	end
	mg:Merge(g)
	Duel.Release(mg,REASON_COST)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x1017) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 and Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)~=0 then
		--Cannot be destroyed by battle or card effect
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(3008)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		g:GetFirst():RegisterEffect(e1)
	end
end
