--Eagle Guardian S/T
function c12340819.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c12340819.con)
	e1:SetTarget(c12340819.target)
	e1:SetOperation(c12340819.operation)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c12340819.handcon)
	c:RegisterEffect(e2)
end
function c12340819.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end

function c12340819.con(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and eg:GetCount()==1 and Duel.GetCurrentChain()==0
end
function c12340819.filter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:GetSummonPlayer()~=tp and c:IsAbleToHand()
end
function c12340819.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c12340819.filter,1,nil,tp) end
	local tc=eg:Filter(c12340819.filter,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
end
function c12340819.spfilter(c,e,tp,atk)
	return c:IsAttackBelow(atk) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_WINDBEAST)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12340819.operation(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetCount()>0 and Duel.SendtoHand(eg,nil,REASON_EFFECT)>0 then
		local tc=eg:GetFirst()
		if tc:GetSummonLocation()==LOCATION_EXTRA
		and Duel.IsExistingMatchingCard(c12340819.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp,tc:GetAttack())
		and Duel.SelectYesNo(tp,aux.Stringid(12340819,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c12340819.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,tc:GetAttack())
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end