--Supreme King Iris magician
local s,id=GetID()
function s.initial_effect(c)
	--Enable pendulum summon
	Pendulum.AddProcedure(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Cannot pendulum summon monsters, except Pendulum monsters
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(s.splimit)
	c:RegisterEffect(e2)
--scale change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetOperation(s.scop1)
	c:RegisterEffect(e3)
--scale change
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetOperation(s.scop2)
	c:RegisterEffect(e4)
	--Special summon itself from hand, then end the Battle Phase
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetRange(LOCATION_HAND)
	e5:SetCondition(s.condition1)
	e5:SetTarget(s.target1)
	e5:SetOperation(s.operation1)
	c:RegisterEffect(e5)
	--indes
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(s.atktg)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	-- Inflict Damage
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,3))
	e7:SetCategory(CATEGORY_ATKCHANGE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_REMOVE)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	--e7:SetRange(LOCATION_REMOVE)
	e7:SetTarget(s.tg)
	e7:SetOperation(s.op)
	c:RegisterEffect(e7)
--indes
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_ADD_SETCODE)
	e8:SetValue(0x10f2)
	c:RegisterEffect(e8)
--indes
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_ADD_SETCODE)
	e9:SetValue(0x1046)
	c:RegisterEffect(e9)
--indes
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_ADD_SETCODE)
	e10:SetValue(0x2073)
	c:RegisterEffect(e10)
--indes
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_ADD_SETCODE)
	e11:SetValue(0x2017)
	c:RegisterEffect(e11)
--indes
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_SINGLE)
	e12:SetProperty(EFFECT_TYPE_SINGLE)
	e12:SetCode(EFFECT_ADD_SETCODE)
	e12:SetValue(0x13b)
	c:RegisterEffect(e12)
--indes
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE)
	e13:SetProperty(EFFECT_TYPE_SINGLE)
	e13:SetCode(EFFECT_ADD_SETCODE)
	e13:SetValue(0xdb)
	c:RegisterEffect(e13)
--indes
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_SINGLE)
	e14:SetProperty(EFFECT_TYPE_SINGLE)
	e14:SetCode(EFFECT_ADD_SETCODE)
	e14:SetValue(0x2016)
	c:RegisterEffect(e14)
--indes
	local e15=Effect.CreateEffect(c)
	e15:SetType(EFFECT_TYPE_SINGLE)
	e15:SetProperty(EFFECT_TYPE_SINGLE)
	e15:SetCode(EFFECT_ADD_SETCODE)
	e15:SetValue(0x99)
	c:RegisterEffect(e15)
--indes
	local e16=Effect.CreateEffect(c)
	e16:SetType(EFFECT_TYPE_SINGLE)
	e16:SetProperty(EFFECT_TYPE_SINGLE)
	e16:SetCode(EFFECT_ADD_SETCODE)
	e16:SetValue(0x98)
	c:RegisterEffect(e16)
end
function s.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp)
	if c:IsType(TYPE_PENDULUM) then return false end
	return (sumtype&SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function s.scop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LSCALE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e2)
end
function s.scop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LSCALE)
	e1:SetValue(12)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e2)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_EXTRA,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc1=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_EXTRA,0,1,1,nil,tp):GetFirst()
	if not tc1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc2=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_EXTRA,0,1,1,tc1,nil,nil):GetFirst()
	Duel.SendtoHand(Group.FromCards(tc1,tc2),nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,Group.FromCards(tc1,tc2))
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE_STEP,1)
	end
end
function s.atktg(e,c)
	return c:IsRace(RACE_DRAGON) or c:IsRace(RACE_SPELLCASTER)
end
function s.indct(e,re,r,rp)
	if bit.band(r,REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
	end
Duel.Draw(tp,2,REASON_EFFECT)
end
