--Fusion Master Of Skeledragons
function c12340120.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	Fusion.AddProcFunRep(c,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),5,true,true)
	--attack twice
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12340120,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c12340120.gycon)
	e1:SetTarget(c12340120.gytg)
	e1:SetOperation(c12340120.gyop)
	c:RegisterEffect(e1)
end

function c12340120.gycon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c12340120.gytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c12340120.gyop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end