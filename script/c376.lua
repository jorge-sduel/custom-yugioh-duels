--Supreme king of dimensional dragon
local s,id=GetID()
function s.initial_effect(c)
	--special summon/attach
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--remain field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3)
	--special summon
	local e23=Effect.CreateEffect(c)
	e23:SetType(EFFECT_TYPE_FIELD)
	e23:SetCode(EFFECT_SPSUMMON_PROC)
	e23:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e23:SetRange(LOCATION_EXTRA)
	e23:SetCondition(s.conditionov)
	e23:SetOperation(s.hncost)
	e23:SetValue(SUMMON_TYPE_XYZ)
	local e24=Effect.CreateEffect(c)
	e24:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e24:SetRange(LOCATION_SZONE)
	e24:SetTargetRange(LOCATION_EXTRA,0)
	e24:SetTarget(s.eftg)
	e24:SetLabelObject(e23)
	c:RegisterEffect(e24)
end
function s.cfilter(c)
	return (c:IsType(TYPE_FUSION) or (c:IsType(TYPE_XYZ) or c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_PENDULUM))) and c:IsType(TYPE_MONSTER)
end
function s.rescon(checkfunc)
	return function(sg,e,tp,mg)
		if not sg:CheckDifferentProperty(checkfunc) then return false,true end
		return Duel.IsExistingMatchingCard(s.hnfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,sg)
	end
end
function s.hnfilter(c,e,tp,sg)
	return c:IsCode(13331639) or c:IsCode(12341305) or (c:IsType(TYPE_FUSION) and c:IsType(TYPE_XYZ) and c:IsType(TYPE_SYNCHRO)) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:CheckFusionMaterial()
			and Duel.GetLocationCountFromEx(tp,tp,sg and (sg+e:GetHandler()) or nil,c)>0
end
function s.hncost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_SZONE+LOCATION_PZONE+LOCATION_OVERLAY+LOCATION_DECK+LOCATION_EXTRA,0,c)
	local checkfunc=aux.PropertyTableFilter(Card.GetSetCard,0x10f2,0x2073,0x2017,0x1046)
	if chk==0 then return aux.SelectUnselectGroup(mg,e,tp,4,4,s.rescon(checkfunc),0) end
	local sg=aux.SelectUnselectGroup(mg,e,tp,4,4,s.rescon(checkfunc),1,tp,HINTMSG_REMOVE,s.rescon(checkfunc))
	Duel.Overlay(c,sg)
	c:CancelToGrave()
end
function s.hntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
Duel.IsExistingTarget(s.hnfilter,tp,LOCATION_MZONE,0,4,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.hnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.hnfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
		c:CancelToGrave()
	end
end
function s.eftg(e,c)
	return c:IsCode(13331639) or c:IsCode(12341305) or (c:IsType(TYPE_FUSION) and c:IsType(TYPE_XYZ) and c:IsType(TYPE_SYNCHRO)) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function s.hspfilter(c)
	return c:IsCode(id)
end
function s.conditionov(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(e:GetHandlerPlayer(),LOCATION_SZONE)+Duel.GetLocationCountFromEx(e:GetHandlerPlayer(),e:GetHandlerPlayer(),nil,c)>0
        and Duel.IsExistingMatchingCard(s.hspfilter,e:GetHandlerPlayer(),LOCATION_SZONE,0,1,nil)
end
function s.operationov(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,s.hspfilter,tp,LOCATION_SZONE,0,1,1,nil)
		local mg1=g:GetFirst():GetOverlayGroup()
			Duel.Overlay(c,mg1)
    Duel.Overlay(c,g)
    c:SetMaterial(g)
end
function s.filter2(c,e,tp)
	return (c:IsCode(12341305) or (c:IsType(TYPE_SYNCHRO) and c:IsType(TYPE_FUSION) and c:IsType(TYPE_XYZ)))
		and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function s.filter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsType(TYPE_FUSION) and c:IsType(TYPE_XYZ)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function s.envfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function s.ffilter(c)
	return c:IsType(TYPE_FUSION)
end
function s.sfilter(c)
	return c:IsType(TYPE_SYNCHRO)
end
function s.xfilter(c)
	return c:IsType(TYPE_XYZ)
end
function s.lfilter(c)
	return c:IsType(TYPE_LINK)
end
function s.pfilter(c)
	return c:IsType(TYPE_PENDULUM)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<-1 then return false end
		if not (Duel.IsExistingMatchingCard(s.envfilter,0,LOCATION_ONFIELD,0,1,nil) or Duel.IsEnvironment(TYPE_LINK)) then
			return Duel.IsExistingMatchingCard(s.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		else
			return Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=-1 then return end
	local g=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if not (Duel.IsExistingMatchingCard(s.envfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) or Duel.IsEnvironment(CARD_SANCTUARY_SKY)) then
		g=Duel.SelectMatchingCard(tp,s.filter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		f=Duel.SelectMatchingCard(tp,s.ffilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		s=Duel.SelectMatchingCard(tp,s.sfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		x=Duel.SelectMatchingCard(tp,s.xfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		x=Duel.SelectMatchingCard(tp,s.pfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	else
		g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		f=Duel.SelectMatchingCard(tp,s.ffilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		s=Duel.SelectMatchingCard(tp,s.sfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		x=Duel.SelectMatchingCard(tp,s.xfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		p=Duel.SelectMatchingCard(tp,s.pfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
		l=Duel.SelectMatchingCard(tp,s.lfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	end
	if #g>0 then
		Duel.Overlay(g,f)
		Duel.Overlay(g,s)
		Duel.Overlay(g,x)
		Duel.Overlay(g,p)
		Duel.Overlay(g,l)
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end
