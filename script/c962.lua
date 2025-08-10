--アドバンスドロー
--Advance Draw
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
		--salvage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))

	e3:SetType(EFFECT_TYPE_IGNITION)

	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,{id,1})
	e3:SetCost(aux.bfgcost)
	e1:SetTarget(s.target1)
	e1:SetOperation(s.activate1)

	c:RegisterEffect(e3)
end
s.listed_series={SET_QLI}
function s.filter(c)
	return c:IsFaceup() and c:IsSetCard(SET_QLI)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.filter,1,false,nil,nil) end
	local g=Duel.SelectReleaseGroupCost(tp,s.filter,1,1,false,nil,nil)
	Duel.Release(g,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetTargetRange(LOCATION_PZONE,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,SET_QLI))
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE|PHASE_END)
		Duel.RegisterEffect(e1,tp)
end
function s.sfilter(c)
	return (c:IsSummonable(true,nil) or c:IsMSetable(true,nil)) and c:IsSetCard(SET_QLI)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_HAND|LOCATION_MZONE,0,1,nil,true,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function s.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.sfilter,tp,LOCATION_HAND|LOCATION_MZONE,0,1,1,nil,true,nil):GetFirst()
	if tc then
		Duel.SummonOrSet(tp,tc,true,nil)
	end
end
