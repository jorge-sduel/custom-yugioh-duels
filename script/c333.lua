--ovtra
function c333.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(97268402,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c333.con)
	e1:SetOperation(c333.desop)
	c:RegisterEffect(e1)
	--pendulum summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC_G)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,10000000)
	e2:SetOperation(c333.penop)
	e2:SetValue(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e2)
end
function c333.con(e)
	local tp=e:GetHandler():GetControler()
	local tc1=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	local tc2=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if not tc1 or not tc2 then return false end
	return tc1:GetLeftScale()==tc2:GetRightScale()
end
function c333.cfilter(c)
	return c:IsType(TYPE_PENDULUM)
end
function c333.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c333.cfilter,tp,LOCATION_PZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local g=Duel.SelectMatchingCard(tp,c333.cfilter,tp,LOCATION_PZONE,0,1,1,nil)
	Duel.Overlay(e:GetHandler(),g)
end
function c333.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c333.cfilter,tp,LOCATION_PZONE,0,2,2,nil)
	Duel.SendtoGrave(g,REASON_RULE)
	c:SetMaterial(g)
Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	Duel.Overlay(c,g)

end
function c333.penfilter(c,e,tp,lscale,rscale)
	local lv=c:GetLevel()
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsType(TYPE_MONSTER)
		and (lv>e:GetHandler():GetRightScale() and lv<5) or (lv>e:GetHandler():GetLeftScale() and lv>0) or c:IsHasEffect(511004423) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,true,false)
		and not c:IsForbidden() and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,true)
end
function c333.penop(e,tp,eg,ep,ev,re,r,rp,c,og)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c333.penfilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,1,ft,nil,e,tp,lscale,rscale)
	og:Merge(g)
	local tc=og:GetFirst()
	if og:GetCount()>0 then
		og:KeepAlive()
		tc=og:GetNext()
	end
end
