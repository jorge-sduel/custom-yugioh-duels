--クリアー・レイヴェン
function c30000016.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_REMOVE_ATTRIBUTE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(c30000016.ratg)
	e1:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCost(c30000016.thcost)
	e2:SetTarget(c30000016.thtg)
	e2:SetOperation(c30000016.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--Special Summon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,30000016)
	e5:SetCost(c30000016.spcost)
	e5:SetTarget(c30000016.sptg)
	e5:SetOperation(c30000016.spop)
	c:RegisterEffect(e5)
end
function c30000016.ratg(e)
	return e:GetHandler()
end
function c30000016.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local cho=0
	local opt=0
	if Duel.IsExistingMatchingCard(c30000016.mfilter,tp,LOCATION_HAND,0,1,nil,1) and Duel.IsExistingMatchingCard(c30000016.stfilter,tp,LOCATION_DECK,0,1,nil,0) then cho=cho+1 end
	if Duel.IsExistingMatchingCard(c30000016.stfilter,tp,LOCATION_HAND,0,1,nil,1) and Duel.IsExistingMatchingCard(c30000016.mfilter,tp,LOCATION_DECK,0,1,nil,0) then cho=cho+2 end
	if chk==0 then return cho~=0 end
	if cho==1 then 
		Duel.SelectOption(tp,aux.Stringid(30000016,0))
		opt=0 
	end
	if cho==2 then 
		Duel.SelectOption(tp,aux.Stringid(30000016,1))
		opt=1 
	end
	if cho==3 then 
		opt=Duel.SelectOption(tp,aux.Stringid(30000016,0),aux.Stringid(30000016,1)) 
	end
	e:SetLabel(opt)
	if opt==0 then Duel.DiscardHand(tp,c30000016.mfilter,1,1,REASON_COST+REASON_DISCARD,nil,1) end
	if opt==1 then Duel.DiscardHand(tp,c30000016.stfilter,1,1,REASON_COST+REASON_DISCARD,nil,1) end
end
function c30000016.mfilter(c,con)
	if con==1 then 
		return c:IsSetCard(0x306) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
	else
		return c:IsSetCard(0x306) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
	end
end
function c30000016.stfilter(c,con)
	if con==1 then
		return ((c:IsSetCard(0x306) and c:IsType(TYPE_SPELL+TYPE_TRAP)) or c:IsCode(33900648)) and c:IsDiscardable()
	else
		return ((c:IsSetCard(0x306) and c:IsType(TYPE_SPELL+TYPE_TRAP)) or c:IsCode(33900648)) and c:IsAbleToHand()
	end
end
function c30000016.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c30000016.stfilter,tp,LOCATION_DECK,0,1,nil,0) or Duel.IsExistingMatchingCard(c30000016.mfilter,tp,LOCATION_DECK,0,1,nil,0) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c30000016.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c30000016.stfilter,tp,LOCATION_DECK,0,1,1,nil,0)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
	if e:GetLabel()==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c30000016.mfilter,tp,LOCATION_DECK,0,1,1,nil,0)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c30000016.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c30000016.spfilter(c,e,tp)
	return c:IsSetCard(0x306) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c30000016.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c30000016.spfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c30000016.spfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c30000016.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetOperation(c30000016.desop)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			tc:RegisterEffect(e1,true)	
		end
	end
end
function c30000016.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end