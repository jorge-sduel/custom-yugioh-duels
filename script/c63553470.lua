--Maresciallo delle Galassie
--Script by XGlitchy30
function c63553470.initial_effect(c)
	--link summon
	Link.AddProcedure(c,c63553470.matfilter,3,3)
	c:EnableReviveLimit()
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCountLimit(1,63553470+1000)
	e0:SetCondition(c63553470.sprcon)
	e0:SetOperation(c63553470.sprop)
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	--activate from deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(63553470,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,63553470)
	e2:SetCondition(c63553470.actcon)
	e2:SetTarget(c63553470.acttg)
	e2:SetOperation(c63553470.actop)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(63553470,2))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,63553170)
	e3:SetCondition(c63553470.thcon)
	e3:SetTarget(c63553470.thtg)
	e3:SetOperation(c63553470.thop)
	c:RegisterEffect(e3)
	--[[set
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(63553470,3))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,63553270)
	e4:SetCondition(c63553470.setcon)
	e4:SetTarget(c63553470.settg)
	e4:SetOperation(c63553470.setop)
	c:RegisterEffect(e4)
	Duel.AddCustomActivityCounter(63553470,ACTIVITY_SPSUMMON,c63553470.counterfilter)
	Duel.AddCustomActivityCounter(61553470,ACTIVITY_CHAIN,c63553470.chainfilter)]]
end
--filters
function c63553470.counterfilter(c)
	return not c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c63553470.chainfilter(re,tp,cid)
	return not (re:IsHasType(EFFECT_TYPE_ACTIVATE) and (re:GetHandler():IsType(TYPE_PENDULUM)))
end
function c63553470.matfilter(c)
	return c:IsType(TYPE_PENDULUM)
end
function c63553470.sprfilter(c)
	return (c:IsFaceup() and c:IsLocation(LOCATION_PZONE) and c:IsType(TYPE_PENDULUM) and Duel.IsExistingMatchingCard(c63553470.sprfilter1,c:GetControler(),LOCATION_PZONE,0,1,c))
end
function c63553470.sprfilter1(c)
	return c:IsType(TYPE_PENDULUM) and c:IsLocation(LOCATION_PZONE) and c:IsFaceup()
end
function c63553470.actfilter(c,tp)
	return c:IsType(TYPE_PENDULUM) and (c:IsLevelBelow(4) or (c.IsEquilibrium and c:IsLevelBelow(8))) and not c:IsForbidden() 
end
function c63553470.drcfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_PZONE) and c:GetPreviousControler()==tp
end
function c63553470.drcfilter2(c,e,tp,eg,ep,ev,re,r,rp)
	return c:GetType()&TYPE_PANDEMONIUM==TYPE_PANDEMONIUM and c:IsPreviousLocation(LOCATION_SZONE) and c:GetPreviousControler()==tp and c:IsPreviousPosition(POS_FACEUP_ATTACK)
		and aux.PandSSetCon(c,nil,c:GetLocation(),c:GetLocation())(nil,e,tp,eg,ep,ev,re,r,rp)
end
function c63553470.checksetfilter(c,e,tp,eg,ep,ev,re,r,rp)
	return aux.PandSSetCon(c,nil,c:GetLocation(),c:GetLocation())(nil,e,tp,eg,ep,ev,re,r,rp)
end
function c63553470.excfilter(c)
	return c:GetType()&TYPE_PANDEMONIUM==TYPE_PANDEMONIUM and c:IsFaceup()
end
--special summon rule
function c63553470.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c63553470.sprfilter,tp,LOCATION_ONFIELD,0,nil)
	return Duel.GetLocationCountFromEx(tp)>0 and g:GetCount()>0 and Duel.GetCustomActivityCount(63553470,tp,ACTIVITY_SPSUMMON)==0
		and Duel.GetCustomActivityCount(61553470,tp,ACTIVITY_CHAIN)==0
end
function c63553470.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c63553470.sprfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=g:Select(tp,1,1,nil)
	local mc=g1:GetFirst()
	if mc:IsType(TYPE_PENDULUM) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g2=g:FilterSelect(tp,c63553470.sprfilter1,1,1,mc)
		g1:Merge(g2)
	end
	Duel.Destroy(g1,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c63553470.splimit)
	Duel.RegisterEffect(e1,tp)
	--[[local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(1,0)
	e2:SetValue(c63553470.aclimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)]]
end
--limit
function c63553470.splimit(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c63553470.aclimit(c)
	return c:IsType(TYPE_PENDULUM)
end
--activate from deck
function c63553470.actcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c63553470.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckPendulumZones(tp) and Duel.IsExistingMatchingCard(c63553470.actfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c63553470.actop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if not Duel.CheckPendulumZones(tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c63553470.actfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	local tc=Duel.CreateToken(tp,g:GetFirst():GetCode())
	if not g:GetFirst().IsEquilibrium then
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	else
		--Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
Duel.Overlay(g:GetFirst(),tc)
		--if not tc:IsLocation(LOCATION_PZONE) then
			--local edcheck=0
			--if g:IsLocation(LOCATION_EXTRA) then edcheck=TYPE_PENDULUM end
		--end
	end
end
--to hand
function c63553470.thcon(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c63553470.drcfilter,1,nil,tp) then
		return true
	else return false end
end
function c63553470.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA+LOCATION_GRAVE)
end
function c63553470.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=nil
	if eg:GetCount()>1 then
		tc=eg:FilterSelect(tp,Card.IsAbleToHand,1,1,nil):GetFirst()
	else
		tc=eg:GetFirst()
	end
	if not tc or not tc:IsAbleToHand() or tc:IsLocation(LOCATION_HAND) then return end
	Duel.SendtoHand(tc,nil,REASON_EFFECT)
end
--set
function c63553470.setcon(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c63553470.drcfilter2,1,nil,e,tp,eg,ep,ev,re,r,rp) then
		return true
	else return false end
end
function c63553470.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c63553470.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not eg:IsExists(c63553470.checksetfilter,1,nil,e,tp,eg,ep,ev,re,r,rp) then return end
	local tc=nil
	if eg:GetCount()>1 then
		local fg=eg:Filter(c63553470.checksetfilter,nil,e,tp,eg,ep,ev,re,r,rp)
		tc=fg:Select(tp,1,1,nil):GetFirst()
	else
		local fg=eg:Filter(c63553470.checksetfilter,nil,e,tp,eg,ep,ev,re,r,rp)
		tc=fg:GetFirst()
	end
	if tc then
		aux.PandSSet(tc,REASON_EFFECT,aux.GetOriginalPandemoniumType(tc))(e,tp,eg,ep,ev,re,r,rp)
		Duel.ConfirmCards(1-tp,tc)
	end
end
