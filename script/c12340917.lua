--Asura- Survival of the Fittest
function c12340917.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c12340917.condition)
	c:RegisterEffect(e1)
	--adjust
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c12340917.adjustop)
	c:RegisterEffect(e2)
	--cannot summon,spsummon,flipsummon
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(1,1)
	e4:SetTarget(c12340917.sumlimit)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_SUMMON)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(1,1)
	e5:SetTarget(c12340917.sumlimit)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(1,1)
	e6:SetTarget(c12340917.sumlimit)
	c:RegisterEffect(e6)
end

function c12340917.condition(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local ct=0
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_MONSTER)
	for i=0,6 do
		local t = math.pow(2, i)
		if g:IsExists(Card.IsAttribute,1,nil,t) then
			ct=ct+1
		end
	end
	return ct>=2
end

function c12340917.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	if sumpos and bit.band(sumpos,POS_FACEDOWN)>0 then return false end
	local tp=sump
	if targetp then tp=targetp end
	return Duel.IsExistingMatchingCard(Card.IsAttribute,targetp,LOCATION_MZONE,0,1,nil,c:GetAttribute())
end
function c12340917.atfilter(c,at)
	return c:IsFaceup() and c:IsAttribute(at)
end
function c12340917.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local g=Group.CreateGroup()
	local c=e:GetHandler()
	for i=0,10 do
		local attr = math.pow(2, i)
		local tg=Duel.GetMatchingGroup(c12340917.atfilter,tp,LOCATION_MZONE,0,nil,attr)
		if tg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(12340917,0))
			local tc=tg:Select(tp,1,1,nil):GetFirst()
			tg:RemoveCard(tc)
			g:Merge(tg)
		end
	end
	for i=0,10 do
		local attr = math.pow(2, i)
		local tg=Duel.GetMatchingGroup(c12340917.atfilter,1-tp,LOCATION_MZONE,0,nil,attr)
		if tg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(12340917,0))
			local tc=tg:Select(1-tp,1,1,nil):GetFirst()
			tg:RemoveCard(tc)
			g:Merge(tg)
		end
	end
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_RULE)
		Duel.Readjust()
	end
end