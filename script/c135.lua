--mirror 1
function c135.initial_effect(c)
	Pendulum.AddProcedure(c)
	--lower
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(135,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCost(c135.cost)
	e1:SetTarget(c135.sptg)
	e1:SetOperation(c135.spop)
	c:RegisterEffect(e1)
end
function c135.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c135.spfilter(c,e,tp)
	return c:IsCode(136) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c135.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c135.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c135.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,135.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local a=Duel.GetAttacker()
		local ag=a:GetAttackableTarget()
		if a:CanAttack() and not a:IsImmuneToEffect(e) and ag:IsContains(tc) then
			Duel.BreakEffect()
			Duel.ChangeAttackTarget(tc)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_UPDATE_ATTACK)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			e3:SetValue(-1000)
			at:RegisterEffect(e3)
		end
	end
end
