--Destiny Hydra
function c12340400.initial_effect(c)
	c:EnableUnsummonable()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12340400,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c12340400.sptg)
	e1:SetOperation(c12340400.spop)
	c:RegisterEffect(e1)
	--spsummon success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340400,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c12340400.hdcon)
	e2:SetTarget(c12340400.hdtg)
	e2:SetOperation(c12340400.hdop)
	c:RegisterEffect(e2)
	--cannot be xyz
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetValue(c12340400.xyzlimit)
	c:RegisterEffect(e3)
end

function c12340400.xyzlimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_REPTILE)
end

function c12340400.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,1,tp,false,false,POS_FACEUP,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c12340400.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,1,tp,1-tp,false,false,POS_FACEUP_DEFENSE)
	end
end

function c12340400.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()==e:GetHandler()
end
function c12340400.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,c)
            or Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,1-tp,1)
end
function c12340400.hdop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tg=Group:CreateGroup()
    if Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,1,c) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local tg2=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,c)
        tg:Merge(tg2)
    end
    if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,c) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
        local tg2=Duel.SelectMatchingCard(1-tp,aux.TRUE,1-tp,LOCATION_MZONE,0,1,1,c)
        tg:Merge(tg2)
    end
    Duel.Destroy(tg,REASON_RULE)
end