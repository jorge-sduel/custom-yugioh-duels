--Chaos Fairy
function c160008888.initial_effect(c)   
c160008888.Is_Evolute=true
if not EVOLUTE_IMPORTED then Duel.LoadScript("proc_evolute.lua") end
	--c:EnableCounterPermit(0x88)
	c:EnableReviveLimit()
	Evolute.AddProcedure(c,nil,2,99)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(160008888,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c160008888.spcost)
	e1:SetOperation(c160008888.spop)
	c:RegisterEffect(e1)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetValue(c160008888.val)
	c:RegisterEffect(e2)
	--Def
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
end
function c160008888.filter1(c,ec,tp)
	return c:IsAttribute(ATTRIBUTE_DARK)
end

function c160008888.filter2(c,ec,tp)
	return c:IsRace(RACE_FAIRY)
end
function c160008888.val(e,c)
	local r=c:GetAttribute()
	if bit.band(r,ATTRIBUTE_DARK)>0 then return 500
	elseif bit.band(r,ATTRIBUTE_LIGHT)>0 then return -400
	else return 0 end
end
function c160008888.filter(c)
	return c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c160008888.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetCustomActivityCount(160008888,tp,ACTIVITY_SPSUMMON)==0 and c:IsCanRemoveCounter(tp,0x111f,3,REASON_COST) end
	c:RemoveCounter(tp,0x111f,3,REASON_COST)
end
function c160008888.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c.Is_Evolute and c~=e:GetLabelObject()
end
function c160008888.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c160008888.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c160008888.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c160008888.filter,tp,LOCATION_HAND,0,1,ft,nil)
	local c=e:GetHandler()
	local tc=g:GetFirst()
	while tc do
	 Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		tc=g:GetNext()
			end
			
end
