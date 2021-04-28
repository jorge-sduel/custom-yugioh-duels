--クリアー・ランペイジ・コロッサス
function c30000010.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,30000020,aux.FilterBoolFunctionEx(Card.IsSetCard,0x306))
	--remove att
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_REMOVE_ATTRIBUTE)
	e1:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c30000010.descon)
	e2:SetTarget(c30000010.destg)
	e2:SetOperation(c30000010.desop)
	c:RegisterEffect(e2)
	--attack all
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c30000010.damcon)
	e4:SetTarget(c30000010.damtg)
	e4:SetOperation(c30000010.damop)
	c:RegisterEffect(e4)
	--battle destroy
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_BATTLE_DESTROYING)
	e5:SetOperation(c30000010.bdop)
	c:RegisterEffect(e5)
end

--att count function
function c30000010.attfilter(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function c30000010.attcount(tp,loc1,loc2)
	local att=0
	if Duel.IsExistingMatchingCard(c30000010.attfilter,tp,loc1,loc2,1,nil,ATTRIBUTE_LIGHT) then att=att+1 end
	if Duel.IsExistingMatchingCard(c30000010.attfilter,tp,loc1,loc2,1,nil,ATTRIBUTE_DARK) then att=att+1 end
	if Duel.IsExistingMatchingCard(c30000010.attfilter,tp,loc1,loc2,1,nil,ATTRIBUTE_WATER) then att=att+1 end
	if Duel.IsExistingMatchingCard(c30000010.attfilter,tp,loc1,loc2,1,nil,ATTRIBUTE_FIRE) then att=att+1 end
	if Duel.IsExistingMatchingCard(c30000010.attfilter,tp,loc1,loc2,1,nil,ATTRIBUTE_EARTH) then att=att+1 end
	if Duel.IsExistingMatchingCard(c30000010.attfilter,tp,loc1,loc2,1,nil,ATTRIBUTE_WIND) then att=att+1 end
	if Duel.IsExistingMatchingCard(c30000010.attfilter,tp,loc1,loc2,1,nil,ATTRIBUTE_DEVINE) then att=att+1 end
	return att
end

function c30000010.descon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c30000010.desfilter(c)
	return c:IsDestructable() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c30000010.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsDestructable() end
	local ct=c30000010.attcount(tp,0,LOCATION_MZONE)
	if chk==0 then return Duel.IsExistingTarget(c30000010.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and ct>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c30000010.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c30000010.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(g,REASON_EFFECT)
end
function c30000010.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_FUSION and c:GetFlagEffect(30000010)>0
end
function c30000010.filter(c)
	return c:IsSetCard(0x3b) and c:IsType(TYPE_NORMAL) and c:IsAbleToDeck()
end
function c30000010.damtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=c30000010.attcount(tp,0,LOCATION_GRAVE+LOCATION_EXTRA)
	if chk==0 then return ct>0 end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*300)
end
function c30000010.damop(e,tp,eg,ep,ev,re,r,rp)
	local ct=c30000010.attcount(tp,0,LOCATION_GRAVE+LOCATION_EXTRA)
	Duel.Damage(1-tp,ct*300,REASON_EFFECT)
end
function c30000010.bdop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(30000010,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end