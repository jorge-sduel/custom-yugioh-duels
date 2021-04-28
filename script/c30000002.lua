--クリア－・シャ－ド
function c30000002.initial_effect(c)
	c:SetUniqueOnField(1,0,30000002)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cost change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_LPCOST_CHANGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetValue(c30000002.free)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c30000002.con)
	e3:SetTarget(c30000002.tg)
	e3:SetOperation(c30000002.op)
	c:RegisterEffect(e3)
	--self destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_SELF_DESTROY)
	e4:SetCondition(c30000002.sdcon)
	c:RegisterEffect(e4)
end
function c30000002.free(e,re,rp,val)
	if Duel.GetCurrentPhase()==PHASE_END and re and re:GetHandler():IsCode(33900648) and re:IsHasType(EFFECT_TYPE_CONTINUOUS) then
		return 0
	else
		return val
	end
end
function c30000002.cfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c30000002.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c30000002.cfilter,1,nil,tp)
end
function c30000002.attfilter(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function c30000002.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local att=0
	if Duel.IsExistingMatchingCard(c30000002.attfilter,tp,0,0x54,1,nil,ATTRIBUTE_LIGHT) then att=att+1 end
	if Duel.IsExistingMatchingCard(c30000002.attfilter,tp,0,0x54,1,nil,ATTRIBUTE_DARK) then att=att+1 end
	if Duel.IsExistingMatchingCard(c30000002.attfilter,tp,0,0x54,1,nil,ATTRIBUTE_WATER) then att=att+1 end
	if Duel.IsExistingMatchingCard(c30000002.attfilter,tp,0,0x54,1,nil,ATTRIBUTE_FIRE) then att=att+1 end
	if Duel.IsExistingMatchingCard(c30000002.attfilter,tp,0,0x54,1,nil,ATTRIBUTE_EARTH) then att=att+1 end
	if Duel.IsExistingMatchingCard(c30000002.attfilter,tp,0,0x54,1,nil,ATTRIBUTE_WIND) then att=att+1 end
	if Duel.IsExistingMatchingCard(c30000002.attfilter,tp,0,0x54,1,nil,ATTRIBUTE_DEVINE) then att=att+1 end
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,att) and att~=0 end
end
function c30000002.filter(c,con,e,tp)
	if con==1 then
		return ((c:IsSetCard(0x306) and c:IsType(TYPE_SPELL+TYPE_TRAP)) or c:IsCode(33900648)) and c:IsAbleToHand()
	end
	if con==2 then
		return c:IsSetCard(0x306) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	if con==3 then
		return ((c:IsSetCard(0x306) and c:IsType(TYPE_SPELL+TYPE_TRAP) or c:IsCode(33900648)) and c:IsAbleToHand()) 
			or (c:IsSetCard(0x306) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
	end
end
function c30000002.op(e,tp,eg,ep,ev,re,r,rp)
	local att=0
	if Duel.IsExistingMatchingCard(c30000002.attfilter,tp,0,0x54,1,nil,ATTRIBUTE_LIGHT) then att=att+1 end
	if Duel.IsExistingMatchingCard(c30000002.attfilter,tp,0,0x54,1,nil,ATTRIBUTE_DARK) then att=att+1 end
	if Duel.IsExistingMatchingCard(c30000002.attfilter,tp,0,0x54,1,nil,ATTRIBUTE_WATER) then att=att+1 end
	if Duel.IsExistingMatchingCard(c30000002.attfilter,tp,0,0x54,1,nil,ATTRIBUTE_FIRE) then att=att+1 end
	if Duel.IsExistingMatchingCard(c30000002.attfilter,tp,0,0x54,1,nil,ATTRIBUTE_EARTH) then att=att+1 end
	if Duel.IsExistingMatchingCard(c30000002.attfilter,tp,0,0x54,1,nil,ATTRIBUTE_WIND) then att=att+1 end
	if Duel.IsExistingMatchingCard(c30000002.attfilter,tp,0,0x54,1,nil,ATTRIBUTE_DEVINE) then att=att+1 end
	local c=e:GetHandler()
	if not Duel.IsPlayerCanDiscardDeck(tp,att) then return end
	Duel.ConfirmDecktop(tp,att)
	local g=Duel.GetDecktopGroup(tp,att)
	if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		if g:IsExists(c30000002.filter,1,nil,1,e,tp) or g:IsExists(c30000002.filter,1,nil,2,e,tp) then
			local cond=3
			if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then cond=cond-2 end
			if not g:IsExists(c30000002.filter,1,nil,1,e,tp) then cond=cond-1 end
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(30000015,1))
			local sg=g:FilterSelect(tp,c30000002.filter,1,1,nil,cond,e,tp)
			local sgc=sg:GetFirst()
			if sgc:IsType(TYPE_MONSTER) then 
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			else
				Duel.SendtoHand(sg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
			end
			g:Sub(sg)
		end
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
	end
end
function c30000002.sdfilter(c)
	return c:IsFaceup() and not c:IsSetCard(0x306)
end
function c30000002.sdcon(e)
	return Duel.IsExistingMatchingCard(c30000002.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end