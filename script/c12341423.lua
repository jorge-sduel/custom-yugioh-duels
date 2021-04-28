--Ancient Oracle Extra
function c12341423.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsLinkSetCard,0x211),2,2)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c12341423.tgtg)
	e1:SetCondition(c12341423.effcon)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetTarget(c12341423.sptg)
	e2:SetOperation(c12341423.spop)
	c:RegisterEffect(e2)
end

function c12341423.tgtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
function c12341423.cfilter(c)
	return c:IsFaceup() and c:IsCode(12341414)
end
function c12341423.effcon(e)
	return not Duel.IsExistingMatchingCard(c12341423.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end

function c12341423.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function c12341423.spfilter(c,e,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0x211) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12341423.spop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.DiscardDeck(p,d,REASON_EFFECT)
	local g=Duel.GetOperatedGroup():Filter(c12341423.spfilter,nil,e,tp)
	local ct=math.min(g:GetCount(),Duel.GetLocationCount(tp,LOCATION_MZONE))
	if ct~=0 and Duel.SelectYesNo(tp,aux.Stringid(12341423,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,ct,nil)
		if tg:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end