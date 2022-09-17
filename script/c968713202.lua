--Tyranic Dragon
c968713202.IsIgnition=true
if not RUNIC_IMPORTED then Duel.LoadScript("proc_runic.lua") end
function c968713202.initial_effect(c)
	--ignition summon
	Runic.AddProcedure(c,c968713202.filter2,c968713202.filter1,1,1)	--Rune Summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(968713202,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c968713202.setcon)
	e1:SetTarget(c968713202.settg)
	e1:SetOperation(c968713202.setop)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
end
function c968713202.filter1(c)
	return c:IsType(TYPE_TRAP)
end
function c968713202.filter2(c)
	return c:IsType(TYPE_MONSTER)
end
function c968713202.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RUNE
end
function c968713202.filter(c)
	return c:GetCode()==57470761 and c:IsSSetable()
end
function c968713202.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c968713202.filter,tp,LOCATION_GRAVE,0,1,nil) end
end
function c968713202.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c968713202.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end
