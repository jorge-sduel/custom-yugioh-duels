--odd-eyes fast wing dragon
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
 Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_SYNCHRO),1,1,Synchro.NonTuner(nil),1,99,s.matfilter)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(57421866,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.matfilter(c,scard,sumtype,tp)
	return c:IsType(TYPE_PENDULUM,scard,sumtype,tp) and c:IsType(TYPE_SYNCHRO,scard,sumtype,tp)
end
function s.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:GetLevel()>0 and c:IsCanBeSynchroMaterial() and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_MZONE,0,1,nil,tp,c)
end
function s.filter2(c)
	return c:IsFaceup() and c:IsLevel(7) and c:IsType(TYPE_PENDULUM) and not c:IsType(TYPE_SYNCHRO) and c:IsCanBeSynchroMaterial()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) and s.filter2(chkc) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(s.filter2,tp,LOCATION_MZONE,0,1,nil)
 and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(57421866,1))
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) or tc:GetLevel()<0 then return end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(1)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_TYPE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetValue(TYPE_TUNER)
	tc:RegisterEffect(e2)
	if c:IsRelateToEffect(e) then
		Duel.SynchroSummon(tp,c,nil)
	end
end
