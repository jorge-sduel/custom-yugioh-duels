--
--Substitute ID
local s,id=GetID()
function s.initial_effect(c)
	local fparams={fusfilter=s.extrafil}
	--Special summon monsters from deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop(Fusion.SummonEffTG(fparams),Fusion.SummonEffOP(fparams)))
	c:RegisterEffect(e1)
	--level up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,{1,id})
	e3:SetCode(EVENT_PHASE|PHASE_STANDBY)
	e3:SetCost(Cost.SelfBanish)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
	--Lists archetype
s.listed_series={SET_DESTRUCTION_SWORD}
	--Check for a tuner and winged beast among available "Dragunity" monsters
function s.spfilter1(c,e,tp)
	return c:IsSetCard(SET_DESTRUCTION_SWORD) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
	--Activation legality
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
		and Duel.IsExistingMatchingCard(s.spfilter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
	--Check for dragon synchro monster
function s.scfilter(c,mg)
	return c:IsSetCard(SET_BUSTER_BLADER)
end
	--Special summon 2 monsters (1 tuner, 1 winged beast) with their effects negated
function s.spop(fustg,fusop)
	return function(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,s.spfilter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		for tc in aux.Next(g1) do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
		if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,CARD_BUSTER_BLADER) 
		--Fusion.RegisterSummonEff(c)	
		fustg(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(tp,aux.Stringid(6205579,0)) then
			Duel.BreakEffect()
			fusop(e,tp,eg,ep,ev,re,r,rp)
		--[[local chkf=tp|FUSPROC_NOTFUSION
	local g=Duel.GetTargetCards(e):Filter(Card.IsCanBeFusionMaterial,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,g,chkf):GetFirst()
	if tc then
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()]]
		end 
    end
  end 
end
function s.filter(c,e,tp,m,chkf)
	return c:IsSetCard(SET_BUSTER_BLADER) and c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and c:CheckFusionMaterial(m,nil,chkf)
end
function s.thfilter(c)
	return c:IsLevelBelow(4) and c:IsSetCard(SET_DESTRUCTION_SWORD) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.extrafil(c)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(SET_BUSTER_BLADER)
end
