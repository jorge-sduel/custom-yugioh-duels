--Asura S/T
function c12340914.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,12340914+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c12340914.condition)
	e1:SetTarget(c12340914.target)
	e1:SetOperation(c12340914.activate)
	c:RegisterEffect(e1)
end

function c12340914.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2
end
function c12340914.filter(c)
	return c:IsLevelAbove(7) and c:IsSetCard(0x281) and c:IsSummonable(true,nil,2)
end
function c12340914.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340914.filter,tp,LOCATION_HAND,0,1,nil) end
end
function c12340914.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=Duel.SelectMatchingCard(tp,c12340914.filter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	if tc then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		Duel.ShuffleHand(tp)
		Duel.Summon(tp,tc,true,nil,2)
		if tc then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetValue(aux.tgoval)
			tc:RegisterEffect(e1)
		end
	end
end