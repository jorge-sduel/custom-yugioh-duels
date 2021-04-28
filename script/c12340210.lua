--Fluid LV12
function c12340210.initial_effect(c)
	c:EnableUnsummonable()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c12340210.elimit)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340210,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCondition(c12340210.spcon)
	e2:SetCost(c12340210.spcost)
	e2:SetTarget(c12340210.sptg)
	e2:SetOperation(c12340210.spop)
	c:RegisterEffect(e2)
	--special summon #2
    local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(12340210,2))
	e3:SetTarget(c12340210.sptg2)
	e3:SetOperation(c12340210.spop2)
	c:RegisterEffect(e3)
	--leave
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD_P)
	e4:SetCondition(c12340210.leavecon)
	e4:SetTarget(c12340210.leavetg)
	e4:SetOperation(c12340210.leaveop)
	c:RegisterEffect(e4)
    --by "Fluid Manipulation"
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(12340202,0))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCondition(c12340210.con)
	e5:SetTarget(c12340210.tg)
	e5:SetOperation(c12340210.op)
	c:RegisterEffect(e5)
	--reg
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetOperation(c12340210.regop)
	c:RegisterEffect(e6)
end

function c12340210.elimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x204)
end

function c12340210.regop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetCurrentPhase()~=PHASE_STANDBY then return false end
    e:GetHandler():RegisterFlagEffect(12340210+50,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_STANDBY,0,1)
end
function c12340210.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(12340210+50)==0
end
function c12340210.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function c12340210.spfilter(c,e,tp)
	return c:IsSetCard(0x204) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:GetLevel()==e:GetHandler():GetLevel()+2
end
function c12340210.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if e:GetHandler():GetSequence()<5 then ft=ft+1 end
	if chk==0 then return ft>0 and Duel.IsExistingMatchingCard(c12340210.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c12340210.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c12340210.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP) then
		--Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		tc:RegisterFlagEffect(tc:GetCode(),RESET_EVENT+0x16e0000,0,0)
        Duel.SpecialSummonComplete()
		tc:CompleteProcedure()
	end
end
function c12340210.spfilter2(c,e,tp)
	return c:IsSetCard(0x204) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:GetLevel()>0
end
function c12340210.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if e:GetHandler():GetSequence()<5 then ft=ft+1 end
	if chk==0 then
        if ft<=0 then return false end
        local g=Duel.GetMatchingGroup(c12340210.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
        local lv=e:GetHandler():GetLevel()
        return g:CheckWithSumEqual(Card.GetLevel,lv,2,ct)
    end
end
function c12340210.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	local c=e:GetHandler()
    local lv=e:GetHandler():GetLevel()
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct<=0 then return end
	local g=Duel.GetMatchingGroup(c12340210.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
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

function c12340210.leavecon(e,se,sp,st)
	return e:GetHandler():IsPreviousLocation(LOCATION_FIELD) and bit.band(r,0x4040)==0x4040 and rp~=tp
		and e:GetHandler():GetPreviousControler()==tp
end
function c12340210.filter(c)
	return c:IsFaceup() 
end
function c12340210.leavetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if e:GetHandler():GetSequence()<5 then ft=ft+1 end
	if chk==0 then
        if ft<=0 then return false end
        local g=Duel.GetMatchingGroup(c12340210.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
        local lv=e:GetHandler():GetLevel() / 2
        return g:CheckWithSumEqual(Card.GetLevel,lv,2,ct)
    end
end
function c12340210.leaveop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	local c=e:GetHandler()
    local lv=e:GetHandler():GetLevel() / 2
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct<=0 then return end
	local g=Duel.GetMatchingGroup(c12340210.spfilter2,tp,LOCATION_HAND+LOCATION_DECK,0,nil,e,tp)
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

function c12340210.con(e,se,sp,st)
	return e:GetHandler():GetFlagEffect(12340210)~=0
	   and Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c12340210.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c12340210.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Destroy(tg,REASON_EFFECT)
	end
end