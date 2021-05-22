--Mirror Knight Calling
function c45.initial_effect(c)
	c:EnableReviveLimit()
	--Special Summon Tokens
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c45.spcon)
	e1:SetTarget(c45.sptg)
	e1:SetOperation(c45.spop)
	c:RegisterEffect(e1)
end
function c45.spcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL
end
function c45.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,4,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,4,tp,0)
end
function c45.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<3 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,329,0x530,0x4011,0,0,1,RACE_WARRIOR,ATTRIBUTE_DARK) then return end
	for i=1,4 do
		local token=Duel.CreateToken(tp,328+i)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		token:AddCounter(0x1106,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EFFECT_DESTROY_REPLACE)
		e1:SetTarget(c45.reptg)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		token:RegisterEffect(e1)
	end
	Duel.SpecialSummonComplete()
end
function c45.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_REPLACE) and e:GetHandler():GetCounter(0x1106)>0 end
	e:GetHandler():RemoveCounter(tp,0x1106,1,REASON_EFFECT)
	return true
end
