--Link
function c12340218.initial_effect(c)
	--link summon
	Link.AddProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x204),2,2)
	c:EnableReviveLimit()
	--[[count materials
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c12340218.con)
	e1:SetOperation(c12340218.op)
	c:RegisterEffect(e1)]]
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340218,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	--e2:SetCondition(c12340218.spcon)
	e2:SetCost(c12340218.spcost)
	e2:SetTarget(c12340218.sptg)
	e2:SetOperation(c12340218.spop)
	c:RegisterEffect(e2)
    --material check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	--e3:SetCondition(c12340218.con)
	e3:SetValue(c12340218.val)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end

function c12340218.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c12340218.val(e)
	local g=e:GetHandler():GetMaterial()
    local lvlsum=0
	local tc=g:GetFirst()
	while tc do
		lvlsum=lvlsum+tc:GetLevel()*1
		tc=g:GetNext()
	end
	e:GetLabelObject():SetLabel(lvlsum)
	--e:GetHandler():RegisterFlagEffect(12340299,RESET_EVENT+0x16e0000,0,lvlsum)
end

function c12340218.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()~=0--e:GetHandler():GetFlagEffect(12340299)~=0
end
function c12340218.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtraAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,0,REASON_COST)
end
function c12340218.spfilter(c,e,tp)
    --local lv=e:GetHandler():GetFlagEffect(12340299)
	local lv=e:GetLabel()
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x204) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:GetLevel()==lv
end
function c12340218.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if e:GetHandler():GetSequence()<5 then ft=ft+1 end
	if chk==0 then return ft>0 and Duel.IsExistingMatchingCard(c12340218.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c12340218.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c12340218.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP) then
		--Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		tc:RegisterFlagEffect(tc:GetCode(),RESET_EVENT+0x16e0000,0,0)
        Duel.SpecialSummonComplete()
		tc:CompleteProcedure()
	end
end