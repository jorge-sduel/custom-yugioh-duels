--created by LeonDuvall of Discord, coded by Lyris
--YC.Orgのスパイマスター・ミステリアス・ミード
local cid,id=GetID()
function cid.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e1:SetCondition(function(e) return Duel.IsExistingMatchingCard(cid.cond,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) end)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.operation)
	c:RegisterEffect(e1)
end
function cid.filter(c)
	return (c:IsSetCard(0x96b) or c:IsSetCard(0xcf6)) and c:IsAbleToHand()
end
function cid.cond(c)
	return (c:IsSetCard(0x96b) or c:IsSetCard(0xcf6)) and c:IsFaceup()
end
function cid.pcfilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckPendulumZones(tp)
		and Duel.IsExistingMatchingCard(cid.pcfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.CheckPendulumZones(tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cid.pcfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
