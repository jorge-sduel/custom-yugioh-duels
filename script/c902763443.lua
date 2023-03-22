--Pandemoniumgraph of Supermacy
local cid,id=GetID()
function cid.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--During your Main Phase: You can Set 1 face-up "Pandemoniumgraph" Pandemonium Monster from your Extra Deck into your Spell/Trap Zone, and if you do, it can be activated this turn. Until the end of the turn you activated this effect, negate the Pandemonium Effects of monsters with the same name as that target. (HOPT1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,id-900000000)
	e1:SetTarget(cid.pctg)
	e1:SetOperation(cid.pcop)
	c:RegisterEffect(e1)
	--If a "Pandemoniumgraph" card in your Pandemonium Zone is destroyed by your opponent's card effect: You can add 1 Pandemonium Monster from your Deck to your Hand. (HOPT2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id-900000100)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetCondition(cid.spcon)
	e2:SetTarget(cid.sptg)
	e2:SetOperation(cid.spop)
	c:RegisterEffect(e2)
end
function cid.pcfilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function cid.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckPendulumZones(tp)
		and Duel.IsExistingMatchingCard(cid.pcfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cid.pcop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.CheckPendulumZones(tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cid.pcfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function cid.distg(e,c)
	local code=e:GetLabel()
	local code1,code2=c:GetOriginalCodeRule()
	return (code1==code or code2==code) and c:GetFlagEffect(726)>0
end
function cid.discon(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local code1,code2=re:GetHandler():GetOriginalCodeRule()
	return re:IsActiveType(TYPE_TRAP) and (code1==code or code2==code)
end
function cid.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
function cid.cfilter(c,tp)
	return c:IsPreviousSetCard(0xcf80) and c:GetPreviousTypeOnField()&TYPE_PENDULUM==TYPE_PENDULUM and c:IsPreviousLocation(LOCATION_PZONE)
		and c:GetPreviousControler()==tp and c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_EFFECT)
end
function cid.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and eg:IsExists(cid.cfilter,1,nil,tp)
end
function cid.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand()
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cid.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
