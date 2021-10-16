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
  e1:SetCost(s.hncost)
	e1:SetTarget(s.hntg)
	e1:SetOperation(s.hnop)
	c:RegisterEffect(e1)
end
function s.cfilter(c)
	return c:IsType(TYPE_FUSION) or (c:IsType(TYPE_XYZ) or c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_PENDULUM)) and c:IsType(TYPE_MONSTER)
end
function s.cfilter(c)
	return (c:IsType(TYPE_FUSION) or c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_XYZ) or c:IsType(TYPE_PENDULUM)) and c:IsType(TYPE_MONSTER)
end
function s.rescon(checkfunc)
	return function(sg,e,tp,mg)
		if not sg:CheckDifferentProperty(checkfunc) then return false,true end
		return Duel.IsExistingMatchingCard(s.hnfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,sg)
	end
end
function s.hnfilter(c,e,tp,sg)
	return c:IsCode(13331639) or (c:IsType(TYPE_FUSION) and c:IsType(TYPE_XYZ) and c:IsType(TYPE_SYNCHRO) and c:IsType(TYPE_PENDULUM) or c:IsType(TYPE_LINK)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,true,true) and c:CheckFusionMaterial()
			and Duel.GetLocationCountFromEx(tp,tp,sg and (sg+e:GetHandler()) or nil,c)>0
end
function s.hncost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE+LOCATION_SZONE+LOCATION_PZONE+LOCATION_OVERLAY+LOCATION_DECK+LOCATION_EXTRA,0,c)
	local checkfunc=aux.PropertyTableFilter(Card.GetSetCard,0x10f2,0x2073,0x2017,0x1046)
	if chk==0 then return c:IsAbleToRemoveAsCost() and aux.SelectUnselectGroup(mg,e,tp,4,4,s.rescon(checkfunc),0) end
	local sg=aux.SelectUnselectGroup(mg,e,tp,4,4,s.rescon(checkfunc),1,tp,HINTMSG_REMOVE,s.rescon(checkfunc))
	Duel.Overlay(c,sg)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_EXTRA) and chkc:IsControler(tp) and s.hnfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.hnfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.hnfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP_ATTACK)==0 then return end
		local mg1=g:GetFirst():GetOverlayGroup()
    Duel.Overlay(tc,mg1)
    Duel.Overlay(tc,c)
    c:SetMaterial(mg1)
	end
end
