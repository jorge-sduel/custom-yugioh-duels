--Ancient Oracle
function c12341403.initial_effect(c)
    --cannot Set
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_LIMIT_SET_PROC)
	e0:SetCondition(c12341403.setcon)
	c:RegisterEffect(e0)
	--discard deck + change pos
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c12341403.distg)
	e1:SetOperation(c12341403.disop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--change pos
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12341403,0))
	e4:SetCategory(CATEGORY_DECKDES+CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetHintTiming(TIMING_BATTLE_PHASE,0x1c0+TIMING_BATTLE_PHASE)
	e4:SetCountLimit(1,12341403)
	e4:SetCondition(c12341403.con2)
	e4:SetTarget(c12341403.tg2)
	e4:SetOperation(c12341403.op2)
	c:RegisterEffect(e4)
end

function c12341403.setcon(e,c,minc)
	if not c then return true end
	return false
end

function c12341403.cfilter(c)
	return c:IsFaceup() and c:IsCode(12341414)
end
function c12341403.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function c12341403.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,2,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(c12341403.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and e:GetHandler():IsAttackPos() then
		Duel.BreakEffect()
		Duel.ChangePosition(e:GetHandler(),POS_FACEUP_DEFENSE)
	end
end

function c12341403.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_DECK
end
function c12341403.filter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c12341403.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c12341403.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12341403.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c12341403.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c12341403.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end