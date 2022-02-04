--Overlay-Magic Connect Force
function c403.initial_effect(c)
	
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(403,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c403.target)
	e1:SetOperation(c403.operation)
	c:RegisterEffect(e1)
	
end

--Gets the number of XYZ Materials on the card
function c403.numMaterials(c)
	if not _G then return 0 end
	local mt=_G["c" .. c:GetOriginalCode()]
	if mt and mt.xyz_count then return mt.xyz_count else return 0 end
end

--First Target
function c403.Condition1(c)
    return c:GetLevel() > 0
end

--Filter for first targets
function c403.fFilter(c,e,tp)
	if not c403.Condition1(c) or not c:IsFaceup() then return false end
	local count = Duel.GetMatchingGroup(c403.sFilter,tp,0,LOCATION_GRAVE,c,e,tp,c:GetLevel()):GetCount()
	return count > 0 and Duel.IsExistingMatchingCard(c403.xyzFilter,tp,LOCATION_EXTRA,0,1,c,e,tp,c:GetLevel(),count+1)
end

--Filter for second or more targets
function c403.sFilter(c,e,tp,lvl)
    return c:GetLevel() == lvl
end

--Filter for XYZ monsters of a certain rank, that require a certain number of XYZ materials or lower
function c403.xyzFilter(c,e,tp,rank,count)
	if c:IsType(TYPE_XYZ) and c:GetRank() == rank then
		local mats = c403.numMaterials(c)
		if mats > 0 and mats <= count then return true end
	end	
	return false
end

--Special Summon target
function c403.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsFaceup() and chkc:IsLocation(LOCATION_GRAVE) end
	if chk==0 then return Duel.IsExistingMatchingCard(c403.fFilter,tp,0,LOCATION_GRAVE,1,nil,e,tp) end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c403.fFilter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp)
	local tc = g1:GetFirst()
	
	local count = Duel.GetMatchingGroup(c403.sFilter,tp,LOCATION_GRAVE,0,tc,e,tp,tc:GetLevel()):GetCount()
	local g2 = Duel.GetMatchingGroup(c403.xyzFilter,tp,LOCATION_EXTRA,0,tc,e,tp,tc:GetLevel(),count+1)
	local minimum = count
	local num = 0
	local xyz = g2:GetFirst()
	while xyz do
		num = c403.numMaterials(xyz)
		if num > 0 and num-1 < minimum then minimum = num-1 end
		xyz = g2:GetNext()
	end
	if minimum <= 0 then minimum = 1 end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c403.sFilter,tp,LOCATION_GRAVE,0,minimum,count,tc,e,tp,tc:GetLevel())
	
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

--Special Summon operation
function c403.operation(e,tp,eg,ep,ev,re,r,rp)

	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	count = g:GetCount()
	if count < 2 then return end
	
	local tc = g:Filter(c403.Condition1,nil):GetFirst()
	if not tc then return end
	
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 and g:Filter(Card.IsLocation,nil,LOCATION_MZONE):GetCount() <= 0 then return end
	
	local sg=Duel.SelectMatchingCard(tp,c403.xyzFilter,tp,LOCATION_EXTRA,0,1,1,tc,e,tp,tc:GetLevel(),count)
	local sc = sg:GetFirst()
	if not sc then return end
	
	Duel.Overlay(sc,g)
	Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,true,true,POS_FACEUP)
	sc:CompleteProcedure()
end