--Transfigured Great Serpent
function c961398231.initial_effect(c)
	--Rune Summon
	c:EnableReviveLimit()
	local r1=Effect.CreateEffect(c)
	r1:SetType(EFFECT_TYPE_FIELD)
	r1:SetCode(EFFECT_SPSUMMON_PROC)
	r1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	r1:SetRange(LOCATION_HAND)
	r1:SetCondition(c961398231.runcon)
	r1:SetOperation(c961398231.runop)
	--r1:SetValue(0x4f000000)
	c:RegisterEffect(r1)
	--cannot special summon
	--local e1=Effect.CreateEffect(c)
	--e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	--e1:SetType(EFFECT_TYPE_SINGLE)
	--e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	--e1:SetValue(c961398231.runlimit)
	--c:RegisterEffect(e1)
	--ToHand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c961398231.destg)
	e2:SetOperation(c961398231.desop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(95457011,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetTarget(c961398231.thtg)
	e3:SetOperation(c961398231.thop)
	c:RegisterEffect(e3)
--
--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetOperation(c961398231.spr)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(961398231,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e5:SetCondition(c961398231.spcon)
	e5:SetCost(c961398231.spcost)
	e5:SetTarget(c961398231.sptg)
	e5:SetOperation(c961398231.spop)
	c:RegisterEffect(e5)
--
       local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetCode(EFFECT_LEVEL_RANK)
	c:RegisterEffect(e8)
--
        local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetCode(EFFECT_CHANGE_LEVEL)
	e9:SetValue(0)
	c:RegisterEffect(e9)
--
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e10:SetCode(EFFECT_ALLOW_NEGATIVE)
	c:RegisterEffect(e10)
end
function c961398231.matfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and (c:GetAttack()==0 or c:GetDefense()==0)
end
function c961398231.matfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c961398231.runfilter1(c)
	return c961398231.matfilter1(c) and Duel.IsExistingMatchingCard(c961398231.matfilter2,c:GetControler(),LOCATION_ONFIELD,0,2,c)
end
function c961398231.runcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c961398231.runfilter1,c:GetControler(),LOCATION_MZONE,0,2,nil)
end
function c961398231.runop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Group.CreateGroup()
	local mt1=Duel.SelectMatchingCard(tp,c961398231.runfilter1,c:GetControler(),LOCATION_MZONE,0,2,2,nil,c)
	local g2=Duel.GetMatchingGroup(c961398231.matfilter2,tp,LOCATION_ONFIELD,0,nil,c)
	g:Merge(mt1)
	g2:Sub(mt1)
	local mt2=g2:Select(tp,2,2,nil)
	g:Merge(mt2)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+0x100000000)
end
function c961398231.runlimit(e,se,sp,st)
	return bit.band(st,0x4f000000)==0x4f000000
end
function c961398231.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c961398231.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
function c961398231.thfilter(c)
	return c:IsSetCard(0xfe9) and c:IsAbleToHand()
end
function c961398231.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c961398231.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c961398231.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c961398231.spr(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:IsPreviousPosition(POS_FACEUP) then
		c:RegisterFlagEffect(961398231,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
	end
end
function c961398231.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetTurnID()~=Duel.GetTurnCount() and c:GetFlagEffect(961398231)>0
end
function c961398231.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c961398231.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	e:GetHandler():ResetFlagEffect(961398231)
end
function c961398231.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	end
end
