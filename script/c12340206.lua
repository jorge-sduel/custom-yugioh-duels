--Fluid LV4
function c12340206.initial_effect(c)
    --effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12340206,1))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c12340206.con)
	e1:SetTarget(c12340206.gytg)
	e1:SetOperation(c12340206.gyop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340206,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCondition(c12340206.spcon)
	e2:SetCost(c12340206.spcost)
	e2:SetTarget(c12340206.sptg)
	e2:SetOperation(c12340206.spop)
	c:RegisterEffect(e2)
	--special summon #2
    local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(12340206,2))
	e3:SetTarget(c12340206.sptg2)
	e3:SetOperation(c12340206.spop2)
	c:RegisterEffect(e3)
	--reg
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c12340206.regop)
	c:RegisterEffect(e4)
end

function c12340206.regop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetCurrentPhase()~=PHASE_STANDBY then return false end
	e:GetHandler():RegisterFlagEffect(12340206+50,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_STANDBY,0,1)
end
function c12340206.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(12340206+50)==0
end
function c12340206.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function c12340206.spfilter(c,e,tp)
	return c:IsSetCard(0x204) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:GetLevel()==e:GetHandler():GetLevel()+2
end
function c12340206.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if e:GetHandler():GetSequence()<5 then ft=ft+1 end
	if chk==0 then return ft>0 and Duel.IsExistingMatchingCard(c12340206.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c12340206.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c12340206.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP) then
		--Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		tc:RegisterFlagEffect(tc:GetCode(),RESET_EVENT+0x16e0000,0,0)
        Duel.SpecialSummonComplete()
		tc:CompleteProcedure()
	end
end
function c12340206.spfilter2(c,e,tp)
	return c:IsSetCard(0x204) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:GetLevel()>0
end
function c12340206.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if e:GetHandler():GetSequence()<5 then ft=ft+1 end
	if chk==0 then
        if ft<=0 then return false end
        local g=Duel.GetMatchingGroup(c12340206.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
        local lv=e:GetHandler():GetLevel()
        return g:CheckWithSumEqual(Card.GetLevel,lv,2,ct)
    end
end
function c12340206.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	local c=e:GetHandler()
    local lv=e:GetHandler():GetLevel()
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct<=0 then return end
	local g=Duel.GetMatchingGroup(c12340206.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
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

function c12340206.con(e,tp)
	return e:GetHandler():GetFlagEffect(12340206)~=0
		and Duel.IsExistingTarget(c12340206.filter,tp,LOCATION_GRAVE,0,3,nil)
        and Duel.IsPlayerCanDraw(tp,1)
end
function c12340206.filter(c)
	return c:IsSetCard(0x204) and c:IsAbleToDeck()
end
function c12340206.gytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c12340206.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c12340206.filter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c12340206.filter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c12340206.gyop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==3 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end