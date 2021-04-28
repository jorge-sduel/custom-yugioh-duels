--beast machine
function c320.initial_effect(c)
	--Activate2
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(320,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c320.cost)
	e1:SetTarget(c320.target2)
	e1:SetOperation(c320.activate2)
	c:RegisterEffect(e1)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(320,1))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,320)
	e4:SetCost(c320.cost1)
	e4:SetTarget(c320.target)
	e4:SetOperation(c320.activate)
	c:RegisterEffect(e4)
end
function c320.filter2(c)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function c320.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c320.filter2,tp,LOCATION_SZONE+LOCATION_HAND,0,1,nil) end
	local ft=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local g=Duel.GetMatchingGroup(c320.filter2,tp,LOCATION_SZONE+LOCATION_HAND,0,nil)
	local ct=math.min(ft-1,#g+1)
	local sg=g:Select(tp,1,ct,nil)
	e:SetLabel(#sg+1)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c320.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,e:GetLabel())
end
function c320.activate2(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c320.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c320.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroupCost(tp,nil,1,false,nil,nil) end
	local sg=Duel.SelectReleaseGroupCost(tp,nil,1,1,false,nil,nil)
	local tc=sg:GetFirst()
	local atk=tc:GetAttack()
	local def=tc:GetDefense()
	local rec=0
	Duel.Release(tc,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(320,3))
	local sel=Duel.SelectOption(tp,aux.Stringid(320,4),aux.Stringid(320,2))
	if sel==0 then rec=atk
	else rec=def end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c320.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
