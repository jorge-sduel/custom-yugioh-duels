--Eagle Drone 
function c141.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(36492575,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,141)
	e1:SetCondition(c141.spcon)
	e1:SetValue(c141.spval)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c141.descon)
	e2:SetTarget(c141.destg)
	e2:SetOperation(c141.desop)
	c:RegisterEffect(e2)
end
function c141.descon(e,tp,eg,ep,ev,re,r,rp,chk)
	return ep~=tp and Duel.GetAttackTarget()==nil
end
function c141.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function c141.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_SZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c141.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x581) and c:IsType(TYPE_LINK)
end
function c141.checkzone(tp)
	local zone=0
	local g=Duel.GetMatchingGroup(c141.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		zone=bit.bor(zone,tc:GetLinkedZone(tp))
	end
	return bit.band(zone,0x1f)
end
function c141.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=c141.checkzone(tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c141.spval(e,c)
	local tp=c:GetControler()
	local zone=c141.checkzone(tp)
	return 0,zone
end