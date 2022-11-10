--Ever-Runic Incantation
if not RUNIC_IMPORTED then Duel.LoadScript("proc_runic.lua") end
function c905312206.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c905312206.target)
	e1:SetOperation(c905312206.activate)
	c:RegisterEffect(e1)
end
function c905312206.filter1(c,e,tp)
	return c:IsFaceup() and c.Is_Runic
		and Duel.IsExistingMatchingCard(c905312206.filter2,tp,LOCATION_DECK,0,1,nil,e,tp,c,c:GetRank(),c:GetRace())
end
function c905312206.filter2(c,e,tp,mc,lv,rc)
	return (c:GetRank()>lv and c:GetRank()<=lv+3) and c.Is_Runic and c:IsRace(rc)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RUNIC,tp,false,true)
end
function c905312206.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c905312206.filter1(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(c905312206.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c905312206.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c905312206.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c905312206.filter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc,tc:GetRank(),tc:GetRace())
	local sc=g:GetFirst()
	if sc then
		local mg=Group.FromCards(tc,e:GetHandler())
		sc:SetMaterial(mg)
		Duel.SendtoGrave(mg,REASON_EFFECT+REASON_MATERIAL+REASON_RUNIC)
		Duel.BreakEffect()
		if Duel.SpecialSummonStep(sc,SUMMON_TYPE_RUNIC,tp,tp,false,true,POS_FACEUP) then
			--cannot be battle target
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
			e1:SetCondition(c905312206.atkcon)
			e1:SetValue(aux.imval1)
			sc:RegisterEffect(e1)
			Duel.SpecialSummonComplete()
		end
		sc:CompleteProcedure()
		mg:DeleteGroup()
	end
end
function c905312206.atkcon(e)
	return Duel.IsExistingMatchingCard(aux.TRUE,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
