--Flaming Angel of Ruins
if not RUNIC_IMPORTED then Duel.LoadScript("proc_runic.lua") end
function c999019282.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	Link.AddProcedure(c,c999019282.matfilter,2,2)
	--disable field
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c999019282.disop)
	c:RegisterEffect(e1)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(70771599,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(c999019282.spcost)
	e3:SetTarget(c999019282.sptg)
	e3:SetOperation(c999019282.spop)
	c:RegisterEffect(e3)
end
function c999019282.matfilter(c,scard,sumtype,tp)
	return c:IsType(TYPE_RITUAL,scard,sumtype,tp) or c.Is_Runic
end
function c999019282.disop(e,tp)
	local c=e:GetHandler()
	local flag1=bit.band(c:GetLinkedZone(tp),0xff00ffff)
	local flag2=bit.band(c:GetLinkedZone(1-tp),0xff00ffff)<<16
	Debug.Message(flag2)
	return flag1+flag2
end
function c999019282.costfilter(c)
	return c:IsType(TYPE_RITUAL) or c:IsType(TYPE_RUNE)
end
function c999019282.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c999019282.costfilter,1,nil) end
	local sg=Duel.SelectReleaseGroup(tp,c999019282.costfilter,1,1,nil)
	Duel.Release(sg,REASON_COST)
end
function c999019282.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c999019282.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
