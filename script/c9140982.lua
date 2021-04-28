--Link Resonator
function c9140982.initial_effect(c)
	c:EnableReviveLimit()
	Link.AddProcedure(c,c9140982.matfilter,1,1)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9140982,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,9140982)
	e1:SetCondition(c9140982.condition)
	e1:SetTarget(c9140982.target)
	e1:SetOperation(c9140982.operation)
	c:RegisterEffect(e1)
	--synchro summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c9140982.syncost)
	e2:SetTarget(c9140982.syntg)
	e2:SetOperation(c9140982.synop)
	c:RegisterEffect(e2)
	--cannot be attack target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c9140982.limscon)
	e3:SetValue(aux.imval1)
	c:RegisterEffect(e3)
end
function c9140982.matfilter(c,lc,sumtype,tp)
	return c:IsSetCard(0x57,lc,sumtype,tp) and c:IsType(TYPE_TUNER,lc,sumtype,tp)
end
function c9140982.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9140982.filter(c,e,tp)
	return c:IsLevelBelow(3) and c:IsSetCard(0x57) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9140982.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c9140982.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9140982.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9140982.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9140982.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9140982.syncost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c9140982.cfilter(c,e,tp,ft)
	local lv=c:GetOriginalLevel()
	return c:GetOriginalType()&TYPE_MONSTER~=0 and lv>0 and c:IsFaceup() and c:IsAbleToGraveAsCost() and (ft>0)
		and Duel.IsExistingMatchingCard(c9140982.synfilter,tp,LOCATION_EXTRA,0,1,nil,lv+2,e,tp)
end
function c9140982.synfilter(c,lv,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_DRAGON) and c:IsType(TYPE_SYNCHRO) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9140982.syntg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCountFromEx(tp,tp,c)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return ft>-0 and Duel.IsExistingMatchingCard(c9140982.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,ft)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c9140982.cfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,ft)
	local tc=g:GetFirst()
	Duel.SendtoGrave(tc,REASON_COST)
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9140982.synop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9140982.synfilter,tp,LOCATION_EXTRA,0,1,1,nil,tc:GetLevel()+2,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9140982.limfil(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c9140982.limscon(e)
	return e:GetHandler():GetLinkedGroup():IsExists(c9140982.limfil,1,nil)
end