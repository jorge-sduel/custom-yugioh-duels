--Flux Auroran
function c22325836.initial_effect(c)

	--XYZ summon
	Xyz.AddProcedure(c,nil,4,2)
	c:EnableReviveLimit()

	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22325836,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCondition(c22325836.sscon)
	e1:SetTarget(c22325836.sstg)
	e1:SetOperation(c22325836.ssop)
	c:RegisterEffect(e1)
end

--Special Summon filter
function c22325836.ssfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end

--Special Summon overaly filter
function c22325836.ssofilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

--Special Summon condition
function c22325836.sscon(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	
	return  c:IsFaceup() and
			c:GetOverlayGroup():IsExists(c22325836.ssofilter,1,nil,e,tp) and
			ft1 > 0 and
			not Duel.IsExistingMatchingCard(c22325836.ssfilter,tp,LOCATION_MZONE,0,1,c)
end

--Secial Summon target
function c22325836.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,22325836)==0 end
	Duel.RegisterFlagEffect(tp,22325836,0,0,0)
end

--Special Summon operation
function c22325836.ssop(e,tp,eg,ep,ev,re,r,rp)

	local c = e:GetHandler()
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	
	if  c:IsFaceup() and
		c:IsRelateToEffect(e) and
		c:GetOverlayGroup():IsExists(c22325836.ssofilter,1,nil,e,tp) and
		ft1 > 0
	then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g = c:GetOverlayGroup():Filter(c22325836.ssofilter,nil,e,tp):Select(tp,ft1,ft1,nil)
		
		if g:GetCount()>0 then
			local tc=g:GetFirst()
			while tc do
				if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
				
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_CANNOT_ATTACK)
					e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
					tc:RegisterEffect(e1)
					local e2 = e1:Clone()
					e2:SetCode(EFFECT_CANNOT_TRIGGER)
					tc:RegisterEffect(e2)
					local e3 = e1:Clone()
					e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
					e3:SetValue(1)
					tc:RegisterEffect(e3)
				end
				
				tc=g:GetNext()
			end
			Duel.SpecialSummonComplete()
		end
		
		Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
	end
end