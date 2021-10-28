--Evolzar Levia
function c202.initial_effect(c)
	--xyz summon
		Xyz.AddProcedure(c,nil,6,2,c202.ovfilter,aux.Stringid(26556950,0),2)
	c:EnableReviveLimit()
--pendulum summon
	Pendulum.AddProcedure(c)
	--destroy & summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12340002,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_PZONE)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	e1:SetCountLimit(1,202)
	e1:SetCost(c202.cost)
	e1:SetTarget(c202.target)
	e1:SetOperation(c202.op)
	c:RegisterEffect(e1)
	--cannot disable summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetTarget(c202.sumtarget)
	c:RegisterEffect(e2)
	--send replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(94,2))
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c202.repcondition)
	e3:SetTarget(c202.reptarget)
	e3:SetOperation(c202.repoperation)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(202,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c202.descost)
	e4:SetOperation(c202.desop)
	c:RegisterEffect(e4,false,REGISTER_FLAG_DETACH_XMAT)
end
c202.pendulum_level=6
function c202.ovfilter(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x504e)
end
function c202.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c202.sumtarget(e,c)
	return c:IsAttribute(ATTRIBUTE_FIRE)
end
function c202.filter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsLevelBelow(7)
end
function c202.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable()	and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c202.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c202.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.Destroy(c,REASON_EFFECT)~=0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c202.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c202.repcondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_PZONE,0)<2
end
function c202.reptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetDestination()==LOCATION_GRAVE end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<0 then return false end
	return Duel.SelectEffectYesNo(tp,c)
end
function c202.repoperation(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	Duel.RaiseEvent(c,47408488,e,0,tp,0,0)
end
function c202.refilter(c)
	return c:IsFaceup()
end
function c202.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c202.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c202.refilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tg=g:GetMaxGroup(Card.GetAttack)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
	end
end
function c202.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c202.refilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tg=g:GetMaxGroup(Card.GetAttack)
		if tg:GetCount()>1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=tg:Select(tp,1,1,nil)
			Duel.Destroy(sg,REASON_EFFECT)
		else Duel.Destroy(tg,REASON_EFFECT) end
	end
end
