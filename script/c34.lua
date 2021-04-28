--ソウル・チャージ
function c34.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c34.sptg)
	e1:SetOperation(c34.spop)
	c:RegisterEffect(e1)
end
function c34.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c34.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,0)
end
function c34.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_EXTRA,0,ft,ft,nil,TYPE_TRAP)
	local tc=g:GetFirst()
	if tc and res and Duel.SelectYesNo(tp,aux.Stringid(16625614,0)) then
		tc:AddMonsterAttribute(TYPE_NORMAL,ATTRIBUTE_DARK,RACE_FIEND,1,0,0)
		Duel.SpecialSummonStep(tc,181,tp,tp,true,false,POS_FACEUP)
		--immune
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c16625614.efilter)
		e1:SetReset(RESET_EVENT+0x47c0000)
		tc:RegisterEffect(e1)
		--cannot be target
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
		e2:SetReset(RESET_EVENT+0x47c0000)
		tc:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
		c:RegisterFlagEffect(34,RESET_EVENT+RESETS_STANDARD,0,0)
	elseif tc and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP,true) then
		c:RegisterFlagEffect(94212438,RESET_EVENT+RESETS_STANDARD,0,0)
	end
end