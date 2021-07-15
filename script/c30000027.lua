--クリアー・オ-ブ
function c30000027.initial_effect(c)
	--remove att
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_REMOVE_ATTRIBUTE)
	e1:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e1)	
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(30000027,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1)
	e2:SetCondition(c30000027.spcon)
	c:RegisterEffect(e2)
	--Tuner
	local ea=Effect.CreateEffect(c)
	ea:SetDescription(aux.Stringid(30000027,1))
	ea:SetType(EFFECT_TYPE_IGNITION)
	ea:SetRange(LOCATION_MZONE)
	ea:SetProperty(EFFECT_FLAG_DELAY)
	ea:SetCountLimit(1,30000027)
	ea:SetCondition(c30000027.tncon)
	ea:SetOperation(c30000027.tnop)
	c:RegisterEffect(ea)
	--Tuner
	local eb=Effect.CreateEffect(c)
	eb:SetDescription(aux.Stringid(30000027,2))
	eb:SetType(EFFECT_TYPE_IGNITION)
	eb:SetRange(LOCATION_MZONE)
	eb:SetProperty(EFFECT_FLAG_DELAY)
	eb:SetCountLimit(1,30000027)
	eb:SetCondition(c30000027.tncon2)
	eb:SetOperation(c30000027.tnop2)
	c:RegisterEffect(eb)
end
function c30000027.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsSetCard,0x306),c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c30000027.tncon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsType(TYPE_TUNER)
end
function c30000027.tnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
function c30000027.tncon2(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsLevel(4)
end
function c30000027.tnop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(4)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
