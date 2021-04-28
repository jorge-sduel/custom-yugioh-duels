--Sin Shooting Quasar Dragon
function c365214612.initial_effect(c)
	c:EnableReviveLimit()
	--Special Summon by Sending 1 "Shooting Quasar Dragon" to the Graveyard
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c365214612.sinsumcon)
	e1:SetOperation(c365214612.sinsumop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(aux.FALSE)
	c:RegisterEffect(e2)
	--Negate the Activation of Card or Effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(365214612,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c365214612.negatecon)
	e3:SetTarget(c365214612.negatetg)
	e3:SetOperation(c365214612.negateop)
	c:RegisterEffect(e3)
	--Special Summon 1 "Malefic Stardust Dragon"
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(365214612,1))
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c365214612.stardustsumcon)
	e4:SetTarget(c365214612.stardustsumtg)
	e4:SetOperation(c365214612.stardustsumop)
	c:RegisterEffect(e4)
	--If "Malefic World" is not Face-Up on the Field, Destroy this Card
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_SELF_DESTROY)
	e5:SetCondition(c365214612.selfdestroycon)
	c:RegisterEffect(e5)
end
function c365214612.sinsumfilter(c)
	return c:IsCode(35952884) and c:IsAbleToGraveAsCost()
end
function c365214612.sinsumcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c365214612.sinsumfilter,c:GetControler(),LOCATION_EXTRA,0,1,nil)
end
function c365214612.sinsumop(e,tp,eg,ep,ev,re,r,rp,c)
	local tc=Duel.GetFirstMatchingCard(c365214612.sinsumfilter,tp,LOCATION_EXTRA,0,nil)
	Duel.SendtoGrave(tc,REASON_COST)
end
function c365214612.negatecon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c365214612.negatetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c365214612.negateop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c365214612.stardustsumcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.IsEnvironment(27564031) 
	and e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c365214612.stardustsumfilter(c,e,tp)
	return c:GetCode()==36521459 and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c365214612.stardustsumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c35952884.stardustsumfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c365214612.stardustsumop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstMatchingCard(c35952884.stardustsumfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if tg then
		Duel.SpecialSummon(tg,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c365214612.selfdestroycon(e)
	return not Duel.IsEnvironment(27564031)
end