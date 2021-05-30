--ovtra
function c333.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(97268402,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetOperation(c333.desop)
	c:RegisterEffect(e1)
end
function c333.cfilter(c)
	return c:IsType(TYPE_PENDULUM)
end
function c333.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c333.cfilter,tp,LOCATION_PZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,c333.cfilter,tp,LOCATION_PZONE,0,1,1,nil)
	Duel.Overlay(e:GetHandler(),g)
end
function c333.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c333.cfilter,tp,LOCATION_PZONE,0,2,2,nil)
	Duel.SendtoGrave(g,REASON_RULE)
	c:SetMaterial(g)
Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	Duel.Overlay(c,g)
end