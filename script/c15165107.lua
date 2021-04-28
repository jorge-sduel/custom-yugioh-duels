--Mystical Maesltrom
function c15165107.initial_effect(c)

	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	
	--Destruction
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(15165107,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c15165107.descon)
	e2:SetTarget(c15165107.destg)
	e2:SetOperation(c15165107.desop)
	c:RegisterEffect(e2)
	
	--Draw
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(15165107,1))
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c15165107.drcon)
	e3:SetCost(c15165107.drcost)
	e3:SetTarget(c15165107.drtg)
	e3:SetOperation(c15165107.drop)
	c:RegisterEffect(e3)
end

--Destruction filter
function c15165107.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup()
end
--Destruction condition
function c15165107.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp 
		and e:GetHandler():IsFaceup()
		and Duel.IsExistingMatchingCard(c15165107.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
--Destruction target
function c15165107.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() and c15165107.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c15165107.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c15165107.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
--Destruction operation
function c15165107.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c15165107.desfilter(tc) and tc:IsDestructable() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

--Draw condition
function c15165107.drcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_DESTROY)~=0
		and bit.band(e:GetHandler():GetPreviousLocation(),LOCATION_ONFIELD)~=0
		and bit.band(e:GetHandler():GetPreviousPosition(),POS_FACEUP)~=0
end
--Draw cost
function c15165107.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,15165107)==0 end
	Duel.RegisterFlagEffect(tp,15165107,RESET_PHASE+PHASE_END,0,1)
end
--Draw target
function c15165107.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
--Draw operation
function c15165107.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end