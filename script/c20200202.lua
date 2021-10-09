--Rainbow Spectrum Blast
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(5133471,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.rettg)
	e2:SetOperation(s.retop)
	c:RegisterEffect(e2)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x2034)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end

function s.spfilter(c)
	return c:IsSetCard(0x1034) and (not c:IsOnField() or c:IsFaceup())
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	local ct=g:GetClassCount(Card.GetCode)	
	local g1=Duel.GetDecktopGroup(tp,ct)
	local g2=Duel.GetDecktopGroup(1-tp,ct)
		Duel.SendtoGrave(g1,nil,REASON_EFFECT)
		Duel.SendtoGrave(g2,nil,REASON_EFFECT)
	
	
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(Card.IsType,nil,TYPE_MONSTER)
	if ct>0 then
		local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local des=dg:Select(tp,1,ct,nil)
			Duel.HintSelection(des)
			Duel.BreakEffect()
			Duel.Destroy(des,REASON_EFFECT)
	end
	local g2=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	if g2:GetClassCount(Card.GetCode)>6 then
		Duel.Draw(tp,2,REASON_EFFECT)
end
end

function s.filter(c)
	return  c:IsSetCard(0x1034)
end
function s.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_REMOVED,0,1,nil) end
	local g=Duel.GetMatchingGroup(s.filter,0,LOCATION_REMOVED,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,0,LOCATION_REMOVED,0,nil)
	Duel.SendtoGrave(g,REASON_EFFECT+REASON_RETURN)
	local g2=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)
	if g2:GetClassCount(Card.GetCode)>6 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(0)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
end
