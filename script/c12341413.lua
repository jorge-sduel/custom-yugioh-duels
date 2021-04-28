--Ancient Oracle
function c12341413.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon proc
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCondition(c12341413.spcon)
	e0:SetOperation(c12341413.spop)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c12341413.spcon2)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12341413,0))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c12341413.damtg)
	e3:SetOperation(c12341413.damop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12341413,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)--+EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c12341413.tdcon)
	e4:SetOperation(c12341413.tdop)
	c:RegisterEffect(e4,false,1)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(12341413,1))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCountLimit(1,12341413)
	e5:SetCondition(c12341413.con2)
	e5:SetTarget(c12341413.tg2)
	e5:SetOperation(c12341413.op2)
	c:RegisterEffect(e5)
end

function c12341413.cfilter(c)
	return c:IsFaceup() and c:IsCode(12341414)
end
function c12341413.spfilter(c)
	return c:IsSetCard(0x211) and c:IsAbleToRemoveAsCost()
end
function c12341413.spcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(e:GetHandlerPlayer(),LOCATION_MZONE)<=0 then return false end
	local g=Duel.GetMatchingGroup(c12341413.spfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,e:GetHandler())
	local ct=g:GetClassCount(Card.GetCode)
	return ct>=5 and Duel.IsExistingMatchingCard(c12341413.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,e:GetHandler())
end
function c12341413.spcon2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(e:GetHandlerPlayer(),LOCATION_MZONE)<=0 then return false end
	local g=Duel.GetMatchingGroup(c12341413.spfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,e:GetHandler())
	local ct=g:GetClassCount(Card.GetCode)
	return ct>=5 and Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_DECK,0)==0
		and Duel.IsExistingMatchingCard(c12341413.cfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,e:GetHandler())
end
function c12341413.spop(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetLocationCount(e:GetHandlerPlayer(),LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(c12341413.spfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
	local rg=Group.CreateGroup()
	for i=1,5 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		if tc then
			rg:AddCard(tc)
			g:Remove(Card.IsCode,nil,tc:GetCode())
		end
	end
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end

function c12341413.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_DECK
end
function c12341413.thfilter(c)
	return c:IsSetCard(0x211) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c12341413.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c12341413.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12341413.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c12341413.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c12341413.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end

function c12341413.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dmg=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_REMOVED,0,nil,0x211)*200
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dmg)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dmg)
end
function c12341413.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

function c12341413.dfilter(c,e,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsPreviousLocation(LOCATION_DECK) and c:GetPreviousControler()==tp and aux.SpElimFilter(c,true)
		and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c12341413.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and eg:IsExists(c12341413.dfilter,1,nil,e,tp)
end
function c12341413.tdop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=eg:Filter(c12341413.dfilter,nil,e,tp)
	if ft<=0 or g:GetCount()<=0 then return end
	ft=math.min(g:GetCount(),ft)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,ft,nil)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
end