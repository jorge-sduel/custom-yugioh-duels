--Fluid LV4
function c12340205.initial_effect(c)
	--effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12340205,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c12340205.con)
	e1:SetTarget(c12340205.tg)
	e1:SetOperation(c12340205.op)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340205,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCondition(c12340205.spcon)
	e2:SetCost(c12340205.spcost)
	e2:SetTarget(c12340205.sptg)
	e2:SetOperation(c12340205.spop)
	c:RegisterEffect(e2)
	--special summon #2
    local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(12340205,2))
	e3:SetTarget(c12340205.sptg2)
	e3:SetOperation(c12340205.spop2)
	c:RegisterEffect(e3)
	--reg
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c12340205.regop)
	c:RegisterEffect(e4)
end

function c12340205.regop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetCurrentPhase()~=PHASE_STANDBY then return false end
	e:GetHandler():RegisterFlagEffect(12340205+50,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_STANDBY,0,1)
end
function c12340205.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(12340205+50)==0
end
function c12340205.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function c12340205.spfilter(c,e,tp)
	return c:IsSetCard(0x204) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:GetLevel()==e:GetHandler():GetLevel()+2
end
function c12340205.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if e:GetHandler():GetSequence()<5 then ft=ft+1 end
	if chk==0 then return ft>0 and Duel.IsExistingMatchingCard(c12340205.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c12340205.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c12340205.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP) then
		--Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		tc:RegisterFlagEffect(tc:GetCode(),RESET_EVENT+0x16e0000,0,0)
        Duel.SpecialSummonComplete()
		tc:CompleteProcedure()
	end
end
function c12340205.spfilter2(c,e,tp)
	return c:IsSetCard(0x204) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:GetLevel()>0
end
function c12340205.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if e:GetHandler():GetSequence()<5 then ft=ft+1 end
	if chk==0 then
        if ft<=1 then return false end
        local g=Duel.GetMatchingGroup(c12340205.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
        local lv=e:GetHandler():GetLevel()
        return g:CheckWithSumEqual(Card.GetLevel,lv,2,ct)
    end
end
function c12340205.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	local c=e:GetHandler()
    local lv=e:GetHandler():GetLevel()
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct<=0 then return end
	local g=Duel.GetMatchingGroup(c12340205.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
	if g:CheckWithSumEqual(Card.GetLevel,lv,2,ct) then
		local fid=c:GetFieldID()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:SelectWithSumEqual(tp,Card.GetLevel,lv,2,ct)
		local tc=sg:GetFirst()
		while tc do
            if Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP) then
                --Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
                tc:RegisterFlagEffect(tc:GetCode(),RESET_EVENT+0x16e0000,0,0)
                Duel.SpecialSummonComplete()
                tc=sg:GetNext()
            end
		end
	end
end

function c12340205.con(e,tp)
	return e:GetHandler():GetFlagEffect(12340205)~=0
		and Duel.IsExistingMatchingCard(c12340205.filter,tp,LOCATION_HAND,0,1,nil,e,tp)
end
function c12340205.filter(c,e,tp)
	return c:IsSetCard(0x204) and c:IsType(TYPE_MONSTER) and c:IsSummonableCard() and c:IsCanBeSpecialSummoned(e,113,tp,false,false)
end
function c12340205.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c12340205.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c12340205.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c12340205.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
        tc:RegisterFlagEffect(tc:GetCode(),RESET_EVENT+0x16e0000,0,0)
        Duel.SpecialSummonComplete()
	end
end