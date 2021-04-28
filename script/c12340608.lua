--Anuak 7*D
function c12340608.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,12340608)
	e1:SetCondition(c12340608.spcon)
	e1:SetOperation(c12340608.spop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340608,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,12340608+EFFECT_COUNT_CODE_OATH)
	e2:SetTarget(c12340608.sumtg)
	e2:SetOperation(c12340608.sumop)
	c:RegisterEffect(e2)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_DAMAGE_STEP_END)
	e5:SetCondition(c12340608.descon)
	e5:SetTarget(c12340608.destg)
	e5:SetOperation(c12340608.desop)
	c:RegisterEffect(e5)
end
function c12340608.spfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and not c:IsPublic()
end
function c12340608.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c12340608.spfilter,c:GetControler(),LOCATION_HAND,0,2,nil)
end
function c12340608.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c12340608.spfilter,tp,LOCATION_HAND,0,2,2,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end

function c12340608.filter1(c)
	return c:IsSetCard(0x208) and c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToGrave()
end
function c12340608.filter2(c)
	return c:IsSetCard(0x208) and c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToGrave()
end
function c12340608.sumtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)    
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_REMOVED) and (c12340608.filter1(chkc) or c12340608.filter2(chkc)) end
	if chk==0 then return Duel.IsExistingTarget(c12340608.filter1,tp,LOCATION_REMOVED,0,1,nil)
        and Duel.IsExistingTarget(c12340608.filter2,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c12340608.filter1,tp,LOCATION_REMOVED,0,1,1,nil)
	local g2=Duel.SelectTarget(tp,c12340608.filter2,tp,LOCATION_REMOVED,0,1,1,nil)
    g:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c12340608.sumop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoGrave(g,REASON_EFFECT)
end

function c12340608.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttackTarget()
end
function c12340608.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=Duel.GetAttacker()
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
end
function c12340608.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsRelateToBattle() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end