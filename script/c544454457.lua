--Malefic Red Dragon Archfiend (ANIME)
function c544454457.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c544454457.spcon)
	e1:SetOperation(c544454457.spop)
	c:RegisterEffect(e1)
	--selfdes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c544454457.descon)
	c:RegisterEffect(e2)
	--destroy all
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(544454457,0))
	e9:SetCategory(CATEGORY_DESTROY)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e9:SetCode(EVENT_BATTLED)
	e9:SetCondition(c544454457.destructcon)
	e9:SetTarget(c544454457.destructtg)
	e9:SetOperation(c544454457.destructop)
	c:RegisterEffect(e9)
end
function c544454457.spfilter(c)
	return c:IsCode(70902743) and c:IsAbleToGraveAsCost()
end
function c544454457.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c544454457.spfilter,c:GetControler(),LOCATION_EXTRA,0,1,nil)
end
function c544454457.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c544454457.spfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c544454457.descon(e)
	return not Duel.IsEnvironment(27564031)
end
function c544454457.destructcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget() and not Duel.GetAttackTarget():IsAttackPos()
end
function c544454457.destructfilter(c)
	return not c:IsAttackPos() and c:IsDestructable()
end
function c544454457.destructtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c544454457.destructfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c544454457.destructop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c544454457.destructfilter,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
