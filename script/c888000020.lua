--Thunder Conductor
function c888000020.initial_effect(c)
	--dark synchro summon
	c:EnableReviveLimit()
	Synchro.AddDarkSynchroProcedure(c,Synchro.NonTuner(nil),nil,2)
	--attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c888000020.atkval)
	c:RegisterEffect(e2)
	--Paralyzation Counter
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(888000020,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c888000020.cttg)
	e3:SetOperation(c888000020.ctop)
	c:RegisterEffect(e3)
	--cannot attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ATTACK)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(c888000020.tg)
	c:RegisterEffect(e4)
	--disable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e5:SetCode(EFFECT_DISABLE)
	e5:SetTarget(c888000020.tg)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_TRIGGER)
	c:RegisterEffect(e6)
end
function c888000020.atkval(e,c)
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(Card.IsFaceup,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,nil)
	return (g1:GetSum(Card.GetRank)*300)+(g2:GetSum(Card.GetLevel)*300)
end
function c888000020.gfilter(c)
	return c:GetCounter(0x890)==0
end
function c888000020.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(c888000020.gfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c888000020.gfilter,tp,0,LOCATION_ONFIELD,1,2,nil)
end
function c888000020.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x890,1)
		tc=g:GetNext()
	end
end
function c888000020.tg(e,c)
	return c:GetCounter(0x890)~=0
end
function c888000020.rcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler())
end