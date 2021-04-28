--Undead
function c12340108.initial_effect(c)
    --cannot Set
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_LIMIT_SET_PROC)
	e6:SetCondition(c12340108.setcon)
	c:RegisterEffect(e6)
    --return to hand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_CHANGE_POS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c12340108.hdcon)
	e3:SetOperation(c12340108.hdop)
	c:RegisterEffect(e3)
    local e4=e3:Clone()
	e4:SetCode(EVENT_CHANGE_POS)
	c:RegisterEffect(e4)
    local e5=e3:Clone()
	e5:SetCode(EVENT_BATTLE_END)
	c:RegisterEffect(e5)
	--special summon in atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c12340108.con)
	e1:SetOperation(c12340108.op)
	c:RegisterEffect(e1)
    --to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340108,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,12340108)
	e2:SetCondition(c12340108.gycond)
	e2:SetTarget(c12340108.gytg)
	e2:SetOperation(c12340108.gyop)
	c:RegisterEffect(e2)
end

function c12340108.setcon(e,c,minc)
	if not c then return true end
	return false
end

function c12340108.hdcon(e)
	return e:GetHandler():IsPosition(POS_FACEUP_DEFENSE)
end
function c12340108.hdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end

function c12340108.con(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():IsPosition(POS_ATTACK)
end
function c12340108.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_CANNOT_ATTACK)
    c:RegisterEffect(e2)
end

function c12340108.gycond(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND+LOCATION_ONFIELD)
end
function c12340108.filter(c)
	return c:IsSetCard(0x202) and c:IsAbleToDeck()
end
function c12340108.gytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c12340108.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) 
		and Duel.IsExistingTarget(c12340108.filter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c12340108.filter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c12340108.gyop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=3 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==3 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end