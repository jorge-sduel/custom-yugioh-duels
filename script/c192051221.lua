--coded by Lyris
--Steelus Toxicatem
function c192051221.initial_effect(c)
	c:EnableReviveLimit()
	--2: Level/Rank 3 EARTH, Level/Rank 3 Dragon
c192051221.Is_Evolute=true
if not EVOLUTE_IMPORTED then Duel.LoadScript("proc_evolute.lua") end
	--c:EnableCounterPermit(0x88)
	c:EnableReviveLimit()
	Evolute.AddProcedure(c,c192051221.mfilter1,2,99,c192051221.rcheck)

	--If this card was Evolute Summoned using "Steelus Colarium", place 2 more E-Counters on it.
	--local e1=Effect.CreateEffect(c)
	--e1:SetType(EFFECT_TYPE_SINGLE)
	--e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	--e1:SetCode(EFFECT_MATERIAL_CHECK)
	--e1:SetValue(c192051221.matcheck)
	--c:RegisterEffect(e1)
	--local e2=Effect.CreateEffect(c)
	--e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	--e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	--e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	--e2:SetCondition(c192051221.tgcon)
	--e2:SetOperation(c192051221.tgop)
	--e2:SetLabelObject(e1)
	--c:RegisterEffect(e2)
	--During each of your Standby Phases: Monsters your opponent controls gain 500 ATK and DEF. During each of your opponent's Standby Phases: monsters they control lose 700 ATK and DEF.
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCondition(c192051221.rmcon)
	e3:SetTarget(c192051221.atktg)
	e3:SetOperation(c192051221.atkop)
	c:RegisterEffect(e3)
	--During each of your End Phases: Remove one E-Counter from this card.
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c192051221.rmcon)
	e4:SetOperation(c192051221.rmop)
	c:RegisterEffect(e4)
	--Negate this card's effects while it has no E-Counters.
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_DISABLE)
	e5:SetCondition(function(e) return e:GetHandler():GetCounter(0x111f)==0 and e:GetHandler():IsLocation(LOCATION_MZONE) end)
	c:RegisterEffect(e5)
end
function c192051221.rcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_EARTH)
		and g:IsExists(Card.IsRace,1,nil,RACE_DRAGON)
end
function c192051221.mfilter1(c)
	return  c:IsLevel(3) or c:IsRank(3)
end
function c192051221.mfilter2(c)
	return c:IsRace(RACE_DRAGON) and aux.EvoluteValue(c)==3
end
function c192051221.matcheck(e,c)
	e:SetLabel(0)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then e:SetLabel(2) end
end
function c192051221.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_EVOLUTE
end
function c192051221.tgop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(tp,0x111f,2,REASON_EFFECT)
end
function c192051221.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c192051221.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(-700)
		tc:RegisterEffect(e1)
c:RemoveCounter(tp,0x111f,1,REASON_EFFECT)
	end
end
function c192051221.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()==tp and c:GetCounter(0x111f)>0
end
function c192051221.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetCounter(0x111f)>0 then c:RemoveCounter(tp,0x111f,1,REASON_EFFECT) end
end
