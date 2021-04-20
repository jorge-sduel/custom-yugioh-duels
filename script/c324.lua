--last draw
function c324.initial_effect(c)
	--Activate2
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(324,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c324.drtg)
	e1:SetOperation(c324.drop)
	c:RegisterEffect(e1)
end
function c324.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c324.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	local tc=Duel.GetOperatedGroup():GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	if (tc:IsType(TYPE_MONSTER)) and Duel.IsPlayerCanDraw(tp,1) then
		Duel.BreakEffect()
		Duel.Draw(tp,tc:GetLevel(),REASON_EFFECT)
		Duel.ShuffleHand(tp)
	end
end
