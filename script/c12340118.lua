--Fusion Master of Bones
function c12340118.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	Fusion.AddProcMix(c,true,true,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),aux.FilterBoolFunctionEx(Card.IsDefenseBelow,1))
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340118,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,12340118)
	e2:SetCondition(c12340118.gycon)
	e2:SetTarget(c12340118.tkntg)
	e2:SetOperation(c12340118.tknop)
	c:RegisterEffect(e2)
end

function c12340118.gycon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and bit.band(c:GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c12340118.tkntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,12340199,0,0x202,0,0,1,RACE_ZOMBIE,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c12340118.tknop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,12340199,0,0x202,0,0,1,RACE_ZOMBIE,ATTRIBUTE_DARK) then
		for i=1,2 do
			local token=Duel.CreateToken(tp,12340199)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		end
		Duel.SpecialSummonComplete()
	end
end