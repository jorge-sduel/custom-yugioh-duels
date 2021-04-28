--Sin Paradox Dragon
function c83101621.initial_effect(c)
	--Synchro Summon
	Synchro.AddProcedure2(c,aux.FilterBoolFunction(Card.IsSetCard,0x23),aux.NonTuner(Card.IsSetCard,0x23))
	c:EnableReviveLimit()
	--Special Summon 1 Synchro Monster of the your Graveyard, Ignoring the Summoning Conditions
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(83101621,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c83101621.specialsumcon)
	e1:SetTarget(c83101621.specialsumtg)
	e1:SetOperation(c83101621.specialsumop)
	c:RegisterEffect(e1)
	--Sin's Curse
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c83101621.sincurseval)
	c:RegisterEffect(e2)
	--If "Malefic World" is not Face-Up on the Field, Destroy this Card
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetCondition(c83101621.selfdestroycon)
	c:RegisterEffect(e3)
end
function c83101621.specialsumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c83101621.specialsumfilter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c83101621.specialsumtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c83101621.specialsumfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c83101621.specialsumfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c83101621.specialsumfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c83101621.specialsumop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
	end
end
function c83101621.sincursefilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c83101621.sincurseval(e,c)
	local c=e:GetHandler()
	local ATK=0
	local g=Duel.GetMatchingGroup(c83101621.sincursefilter,e:GetOwnerPlayer(),LOCATION_MZONE,0,c)
	local tc=g:GetFirst()
	while tc do
	ATK=ATK+tc:GetAttack()
	tc=g:GetNext()
	end
	return -ATK
end
function c83101621.selfdestroycon(e)
	return not Duel.IsEnvironment(27564031)
end