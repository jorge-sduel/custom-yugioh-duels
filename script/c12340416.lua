--Blazing Hydra Link
function c12340416.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	Link.AddProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_REPTILE),2,99,c12340416.linkcheck)
	--indes & cannot target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetValue(aux.tgoval)
	e1:SetCondition(c12340416.effcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetValue(c12340416.indval)
	c:RegisterEffect(e2)
    --sp summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12340416,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCost(c12340416.spcost)
	e3:SetTarget(c12340416.sptg)
	e3:SetOperation(c12340416.spop)
	c:RegisterEffect(e3)
end

function c12340416.linkcheck(g,lc)
	return g:IsExists(Card.IsType,1,nil,TYPE_XYZ)
end

function c12340416.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end
function c12340416.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRace(RACE_REPTILE)
end
function c12340416.effcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c12340416.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c12340416.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end

function c12340416.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c12340416.spfilter(c,e,tp,zone)
	return c:IsSetCard(0x206) and c:IsRace(RACE_REPTILE) and not c:IsType(TYPE_XYZ)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE,tp,zone)
end
function c12340416.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=Duel.GetLinkedZone(tp)&0x1f
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c12340416.spfilter(chkc,e,tp,zone) end
	if chk==0 then return e:GetHandler():GetLinkedZone(tp)>0
		and Duel.IsExistingMatchingCard(c12340416.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c12340416.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c12340416.spop(e,tp,eg,ep,ev,re,r,rp)
	local zone=Duel.GetLinkedZone(tp)&0x1f
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE,zone)
	end
end