--all summon
local s,id=GetID()
function s.initial_effect(c)
	--pendulum summon
	Pendulum.AddProcedure(c)
	--add type
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_ADD_TYPE)
	e0:SetValue(TYPE_LINK)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_LIMIT_ZONE)
	c:RegisterEffect(e1)
	--add Linkmarker
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_ADD_LINKMARKER)
	e2:SetValue(LINK_MARKER_TOP_RIGHT)
	c:RegisterEffect(e2)
	--add Linkmarker
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_ADD_LINKMARKER)
	e3:SetValue(LINK_MARKER_TOP_LEFT)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_TYPE_SINGLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_ADD_RACE)
	e4:SetValue(RACE_SPELLCASTER)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_TYPE_SINGLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_SET_BASE_ATTACK)
	e5:SetValue(1000)
	c:RegisterEffect(e5)
	--indes
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_TYPE_SINGLE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCode(EFFECT_SET_BASE_DEFENSE)
	e8:SetValue(1000)
	c:RegisterEffect(e8)
	--indes
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_TYPE_SINGLE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EFFECT_ADD_ATTRIBUTE)
	e9:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e9)
--
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e10:SetRange(LOCATION_SZONE)
	e10:SetOperation(s.atkop)
	c:RegisterEffect(e10)
	--Reduce Damage to 0
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(id,1))
	e11:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e11:SetType(EFFECT_TYPE_QUICK_O)
	e11:SetCode(EVENT_FREE_CHAIN)
	e11:SetRange(LOCATION_SZONE)
	e11:SetCost(s.negcost)
	e11:SetOperation(s.negop)
	c:RegisterEffect(e11)
--
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(id,2))
	e12:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES+CATEGORY_SPECIAL_SUMMON)
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e12:SetProperty(EFFECT_FLAG_DELAY)
	e12:SetCode(EVENT_SPSUMMON_SUCCESS)
	e12:SetRange(LOCATION_SZONE)
	e12:SetCountLimit(1)
	e12:SetTarget(s.target)
	e12:SetOperation(s.operation)
	c:RegisterEffect(e12)
end
s.pendulum_level=2
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(tp,ev/2)
	Duel.ChangeBattleDamage(1-tp,ev/2)
end
function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
s.ritfilter=aux.FilterFaceupFunction(Card.IsRitualMonster)
function s.rittg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,2)
end
s.fusfilter=aux.FilterFaceupFunction(Card.IsType,TYPE_FUSION)
function s.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.fustg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
s.synfilter=aux.FilterFaceupFunction(Card.IsType,TYPE_SYNCHRO)
function s.syntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
end
s.xyzfilter=aux.FilterFaceupFunction(Card.IsType,TYPE_XYZ)
function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return s.rittg(e,tp,eg,ep,ev,re,r,rp,0) or s.fustg(e,tp,eg,ep,ev,re,r,rp,0)
		or s.syntg(e,tp,eg,ep,ev,re,r,rp,0) or s.xyztg(e,tp,eg,ep,ev,re,r,rp,0) end
	if s.rittg(e,tp,eg,ep,ev,re,r,rp,0) then 
		s.rittg(e,tp,eg,ep,ev,re,r,rp,1)
	end
	if s.fustg(e,tp,eg,ep,ev,re,r,rp,0) then 
		s.fustg(e,tp,eg,ep,ev,re,r,rp,1)
	end
	if s.syntg(e,tp,eg,ep,ev,re,r,rp,0) then 
		s.syntg(e,tp,eg,ep,ev,re,r,rp,1)
	end
	if s.xyztg(e,tp,eg,ep,ev,re,r,rp,0) then 
		s.xyztg(e,tp,eg,ep,ev,re,r,rp,1)
	end
end
function s.ritop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,2,REASON_EFFECT)==2 then
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
Duel.Recover(tp,700,REASON_EFFECT)
	end
end
function s.fusop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
Duel.Damage(1-tp,700,REASON_EFFECT)
	end
end
function s.synop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		tc:UpdateAttack(700,nil,c)
Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		tc:UpdateAttack(-700,nil,c)
Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if s.rittg(e,tp,eg,ep,ev,re,r,rp,0) then 
		s.ritop(e,tp,eg,ep,ev,re,r,rp)
	end
	if s.fustg(e,tp,eg,ep,ev,re,r,rp,0) then 
		Duel.BreakEffect()
		s.fusop(e,tp,eg,ep,ev,re,r,rp)
	end
	if s.syntg(e,tp,eg,ep,ev,re,r,rp,0) then 
		Duel.BreakEffect()
		s.synop(e,tp,eg,ep,ev,re,r,rp)
	end
	if s.xyztg(e,tp,eg,ep,ev,re,r,rp,0) then 
		Duel.BreakEffect()
		s.xyzop(e,tp,eg,ep,ev,re,r,rp)
	end
end