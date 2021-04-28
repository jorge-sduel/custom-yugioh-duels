--Sin Tune
function c1000000940.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(c1000000940.condition)
	e1:SetTarget(c1000000940.target)
	e1:SetOperation(c1000000940.activate)
	c:RegisterEffect(e1)
end
function c1000000940.cfilter(c,tp)
	return c:IsSetCard(0x23) and c:IsType(TYPE_MONSTER) and c:GetPreviousControler()==tp
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end
function c1000000940.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c1000000940.cfilter,1,nil,tp)
end
function c1000000940.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c1000000940.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end