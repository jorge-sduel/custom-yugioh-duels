--Ancient Oracle
function c12341414.initial_effect(c)
	c:EnableCounterPermit(0x53)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk&def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x211))
	e2:SetValue(300)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--to grave
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DECKDES)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c12341414.descon)
	e4:SetTarget(c12341414.destg)
	e4:SetOperation(c12341414.desop)
	c:RegisterEffect(e4)
	--Destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(12341414,0))
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTarget(c12341414.desreptg)
	e5:SetOperation(c12341414.desrepop)
	c:RegisterEffect(e5)
end

function c12341414.spfilter(c,e,tp,lv)
	return c:IsSetCard(0x211) and c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12341414.descon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c12341414.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function c12341414.filter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsSetCard(0x211) and c:IsType(TYPE_MONSTER)
end
function c12341414.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.DiscardDeck(p,d,REASON_EFFECT)
	local dg=Duel.GetOperatedGroup()
	local ct=dg:FilterCount(c12341414.filter,nil)
	if ct>0 then
		e:GetHandler():AddCounter(0x53,ct)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c12341414.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,e:GetHandler():GetCounter(0x53))
		and Duel.SelectYesNo(tp,aux.Stringid(12341414,0)) then
			Duel.BreakEffect()
			local g=Duel.SelectMatchingCard(tp,c12341414.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,e:GetHandler():GetCounter(0x53))
			if g:GetCount()>0 then
				Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end

function c12341414.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_REPLACE+REASON_RULE)
		and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,12341414) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c12341414.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardHand(tp,Card.IsCode,1,1,REASON_EFFECT+REASON_DISCARD,nil,12341414)
end