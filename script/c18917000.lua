--Timebreaker
if not REVERSEPENDULUM_IMPORTED then Duel.LoadScript("proc_reverse_pendulum.lua") end
c1891700.IsRPendulum=true
function c18917000.initial_effect(c)
   RPendulum.AddProcedure(c)
	--opponent splimit
	--local e3=Effect.CreateEffect(c)
	--e3:SetType(EFFECT_TYPE_FIELD)
	--e3:SetRange(LOCATION_PZONE)
	--e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	--e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	--e3:SetTargetRange(0,1)
	--e3:SetCondition(c18917000.psopcon)
	--e3:SetTarget(c18917000.psoplimit)
	--c:RegisterEffect(e3)
	--Self Destroy
	--local e4=Effect.CreateEffect(c)
	--e4:SetType(EFFECT_TYPE_IGNITION)
	--e4:SetRange(LOCATION_PZONE)
	--e4:SetCategory(CATEGORY_DESTROY)
	--e4:SetDescription(aux.Stringid(18917000,1))
	--e4:SetOperation(c18917000.selfDes)
	--c:RegisterEffect(e4)
	--Special Summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(18917000,2))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetCountLimit(1)
	e5:SetTarget(c18917000.sstg)
	e5:SetOperation(c18917000.ssop)
	c:RegisterEffect(e5)
	--Disact
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_ATTACK_ANNOUNCE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c18917000.limcon)
	e6:SetOperation(c18917000.limop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e7)
	--Level
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(18917000,3))
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetCountLimit(1)
	e8:SetTarget(c18917000.lvtg)
	e8:SetOperation(c18917000.lvop)
	c:RegisterEffect(e8)
end
function c18917000.penFilter(c,e,tp,lscale,rscale,lvchk)
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
		and (lvchk or (lv<lscale and lv>rscale) or c:IsHasEffect(511004423)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false)
		and not c:IsForbidden()
end
function c18917000.actcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_MONSTER)
end

function c18917000.limcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	return tc and tc:IsControler(tp) and tc:IsSetCard(0xb00)
end
function c18917000.limop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c18917000.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c18917000.aclimit(e,re,tp)
	return true
end
function c18917000.lvfilter(c,c2)
	return c:IsFaceup() and c:GetLevel()>0 and c:GetLevel()~=c2:GetLevel()
end
function c18917000.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c18917000.lvfilter(chkc,c) end
	if chk==0 then return Duel.IsExistingTarget(c18917000.lvfilter,tp,LOCATION_MZONE,0,1,c,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c18917000.lvfilter,tp,LOCATION_MZONE,0,1,1,c,c)
end
function c18917000.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(tc:GetLevel())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
function c18917000.ssfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xb00)
		and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c18917000.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c18917000.ssfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c18917000.ssop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetLocationCount(tp,LOCATION_MZONE)>0) then return end
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,c18917000.ssfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--If both cards in your PZ are Reverse Pendulums, then your opponent's PS is limited.
--0xb00 == reverse pendulum set code
function c18917000.psopcon(e,c)
	local tp=e:GetHandler()
	local scleft=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local scright=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	return scleft and scright and scleft:IsSetCard(0xb00) and scright:IsSetCard(0xb00)
end
function c18917000.psoplimit(e,c,sump,sumtype,sumpos,targetp)
	local lsc=Duel.GetFieldCard(tp,LOCATION_SZONE,6):GetLeftScale()
	local rsc=Duel.GetFieldCard(tp,LOCATION_SZONE,7):GetRightScale()
	if rsc>lsc then
		return (c:GetLevel()>lsc and c:GetLevel()<rsc) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
	else
		return (c:GetLevel()>rsc and c:GetLevel()<lsc) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
	end
end
