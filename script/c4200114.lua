--created & coded by Swag
local cid,id=GetID()
cid.dfc_front_side=id+1
function cid.initial_effect(c)
	Link.AddProcedure(c,nil,2)
	c:EnableReviveLimit()
	--c:SetSPSummonOnce(id)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cid.sscon)
	e2:SetTarget(cid.sstg)
	e2:SetOperation(cid.ssop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cid.syncon)
	e3:SetTarget(cid.syntg)
	e3:SetOperation(cid.synop)
	c:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BECOME_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return rp~=tp and re and eg:IsContains(e:GetHandler()) end)
	e4:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		if chk==0 then return c.dfc_front_side end
		Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	end)
	e4:SetOperation(cid.ope)
	c:RegisterEffect(e4)
--[[place
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetTarget(cid.targetf)
	e5:SetOperation(cid.operationf)
	c:RegisterEffect(e5)]]
end
function cid.ope(e,tp,eg,ep,ev,re,r,rp,chk)
		local c=e:GetHandler()
		local seq=c:GetSequence()
		local tcode=c.dfc_front_side
	--	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or not tcode then return false end
	--change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetValue(id+1)
	c:RegisterEffect(e1)
	--token type
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_ADD_TYPE)
	e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e4:SetValue(TYPE_TOKEN)
	c:RegisterEffect(e4)
	--local tg=Group.FromCards(c)
	--while Duel.GetLocationCount(tp,LOCATION_MZONE)>0 do
		local token=Duel.CreateToken(tp,id+1)
	Duel.ChangePosition(c,POS_FACEDOWN_ATTACK,0,POS_FACEDOWN_DEFENSE,0)
	Duel.SendtoDeck(c,nil,-2,REASON_RULE)
	Duel.SendtoDeck(c,nil,0,REASON_RULE)
	Duel.SendtoDeck(c,nil,-2,REASON_RULE)
		Duel.MoveToField(token,tp,tp,LOCATION_MZONE,POS_FACEDOWN_ATTACK,true,(1<<seq))
	Duel.ChangePosition(token,POS_FACEDOWN_ATTACK,0,POS_FACEDOWN_DEFENSE,0)
		--tg:AddCard(token)
			--token:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		--token type
		local e4b=e4:Clone()
		e4b:SetReset(RESET_EVENT+RESETS_STANDARD)
		e4b:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		token:RegisterEffect(e4b)
	--change name
	local e5b=Effect.CreateEffect(c)
	e5b:SetType(EFFECT_TYPE_SINGLE)
	e5b:SetCode(EFFECT_SET_PROC)
	e5b:SetValue(SUMMON_TYPE_LINK)
	token:RegisterEffect(e5b)
		--[[destroy damage
		local e6=Effect.CreateEffect(c)
		e6:SetCategory(CATEGORY_DAMAGE)
		e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e6:SetCode(EVENT_LEAVE_FIELD)
		e6:SetOperation(cid.damop)
		token:RegisterEffect(e6)
	--destroy damage
		local e7=Effect.CreateEffect(c)
		e7:SetCategory(CATEGORY_DAMAGE)
		e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e7:SetCode(EVENT_LEAVE_FIELD)
		e7:SetOperation(cid.damop)
		c:RegisterEffect(e7)]]
--	end
end
function cid.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_DESTROY) then
		local d=c:GetPreviousAttackOnField()
	end
	Duel.SendtoDeck(c,nil,-2,REASON_RULE)
	e:Reset()
end
function cid.lcheck(g)
	return g:GetClassCount(Card.GetLinkAttribute)==g:GetCount() and g:GetClassCount(Card.GetLinkRace)==g:GetCount()
end
function cid.sscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cid.filter(c,e,tp,zone)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function cid.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone(tp)&0x1f
		return zone~=0 and Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_DECK,0,1,nil,e,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cid.ssop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)&0x1f
	if zone~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cid.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,zone)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
		end
	end
end
function cid.seqcfilter(c,tp,lg)
	return c:IsType(TYPE_SYNCHRO) and lg:IsContains(c)
end
function cid.syncon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return eg:IsExists(cid.seqcfilter,1,nil,tp,lg)
end
function cid.syntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local zone=e:GetHandler():GetLinkedZone(tp)&0x1f
		return zone~=0 and Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cid.synop(e,tp,eg,ep,ev,re,r,rp)
	local zone=e:GetHandler():GetLinkedZone(tp)&0x1f
	if zone~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cid.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,zone)
		end
	end
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.filter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEDOWN_DEFENSE,true)
			tc:SetStatus(STATUS_SUMMON_TURN,true)
	end
end
