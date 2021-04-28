--Fluid Reunion
function c12340223.initial_effect(c)
		c:EnableReviveLimit()
	--fusion material	
Fusion.AddProcFunRep(c,c12340223.ffilter,2,false)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
    --special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12340223,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1)
	e3:SetCost(c12340223.spcost)
	e3:SetOperation(c12340223.spop)
	c:RegisterEffect(e3)
	--shuffle
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12340223,1))
	e4:SetCategory(CATEGORY_TO_DECK)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetCountLimit(1)
	e4:SetCondition(c12340223.mtcon)
	e4:SetOperation(c12340223.mtop)
	c:RegisterEffect(e4)
end
function c12340223.ffilter(c)
	return c:IsSetCard(0x1204) or c:IsSetCard(0x204)
	end
function c12340223.costfilter(c,e,tp,sc)
    return (c:IsFaceup() or not c:IsLocation(LOCATION_MZONE))
        and c:IsSetCard(0x204) and c:GetLevel()>0 and c:IsAbleToDeckOrExtraAsCost()
        and Duel.IsExistingMatchingCard(c12340223.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetLevel())
end
function c12340223.spfilter(c,e,tp,lvl)
	return c:IsSetCard(0x204) and c:IsType(TYPE_MONSTER) and c:IsLevel(lvl*2) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c12340223.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c12340223.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,c,e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c12340223.costfilter,tp,LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND,0,1,1,c,e,tp,c)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	e:SetLabel(g:GetFirst():GetLevel())
end
function c12340223.spop(e,tp,eg,ep,ev,re,r,rp)
	local lvl=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c12340223.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,lvl):GetFirst()
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP) then
		tc:RegisterFlagEffect(tc:GetCode(),RESET_EVENT+0x16e0000,0,0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
		tc:CompleteProcedure()
	end
end

function c12340223.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c12340223.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c12340223.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	local g=Duel.GetMatchingGroup(c12340223.cfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=g:Select(tp,1,1,nil)
	Duel.SendtoDeck(tg,nil,2,REASON_COST)
end