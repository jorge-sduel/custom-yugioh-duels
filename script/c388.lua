--vendread regurgitation
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROY)
	e1:SetCondition(s.conditionat)
	e1:SetTarget(s.targetat)
	e1:SetOperation(s.operationat)
	c:RegisterEffect(e1)
end
function s.conditionat(e,tp,eg,ev,ep,re,r,rp)
	local egf=eg:Filter(Card.IsType,nil,TYPE_RITUAL)
	local egc=eg:FilterCount(Card.IsType,nil,TYPE_RITUAL)
	if egc==1 then e:SetLabelObject(egf:GetFirst()) end
	return egc==1
end
function s.filter(c,e,tp,sc)
	local scm=sc:GetMaterial()
	return #scm>0 and scm:IsContains(c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,true,false,POS_FACEUP_ATTACK,tp)
end
function s.targetat(e,tp,eg,ev,ep,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp,e:GetLabelObject()) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	local tg=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,ft,nil,e,tp,e:GetLabelObject())
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tg,#tg,0,0)
end
function s.operationat(e,tp,eg,ev,ep,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	local tg=Duel.GetTargetCards(e)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ft=1 end
	if ft>0 and #tg>ft then tg=tg:Select(tp,1,ft,nil) end
	if ft>0 and #tg>0 then
		Duel.SpecialSummon(tg,SUMMON_TYPE_SPECIAL,tp,tp,true,false,POS_FACEUP)
		local tc=tg:GetFirst()
		while tc do
			 local e1=Effect.CreateEffect(c)
			 e1:SetType(EFFECT_TYPE_SINGLE)
			 e1:SetCode(EFFECT_INDESTRUCTABLE)
			 e1:SetValue(1)
			 e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			 tc:RegisterEffect(e1)
			 tc=tg:GetNext()
		end
	end
end