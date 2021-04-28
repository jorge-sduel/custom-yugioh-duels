--Dark Android Behemoth
function c99200171.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcFun2(c,aux.FilterBoolFunction(Card.IsCode,99200151),c99200171.ffilter,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c99200171.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c99200171.sprcon)
	e2:SetTarget(c99200171.sprtg)
	e2:SetOperation(c99200171.sprop)
	c:RegisterEffect(e2)
	--immune effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c99200171.immfilter)
	c:RegisterEffect(e3)
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(c99200171.aclimit)
	e4:SetCondition(c99200171.actcon)
	c:RegisterEffect(e4)
	--update ATK
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetTarget(c99200171.tg1)
	e5:SetValue(400)
	c:RegisterEffect(e5)
end
function c99200171.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c99200171.ffilter(c)
	return not c:IsRace(RACE_MACHINE)
end
function c99200171.spfilter1(c,tp,ft)
	if c:IsCode(99200151) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial(true) and (c:IsControler(tp) or c:IsFaceup()) then
		if ft>0 or (c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)) then
			return Duel.IsExistingMatchingCard(c99200171.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,tp)
		else
			return Duel.IsExistingMatchingCard(c99200171.spfilter2,tp,LOCATION_MZONE,0,1,c,tp)
		end
	else return false end
end
function c99200171.spfilter2(c,tp)
	return not c:IsRace(RACE_MACHINE) and c:IsAbleToGraveAsCost() and c:IsCanBeFusionMaterial() and (c:IsControler(tp) or c:IsFaceup())
end
function c99200171.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c99200171.spfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tp,ft)
end
function c99200171.sprtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c99200171.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99200171,0))
	local g1=Duel.SelectMatchingCard(tp,c99200171.spfilter1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tp,ft)
	local tc=g1:GetFirst()
	local g=Duel.GetMatchingGroup(c99200171.spfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,tc,tp)
	local g2=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99200171,1))
	if ft>0 or (tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE)) then
		g2=g:Select(tp,1,1,nil)
	else
		g2=g:FilterSelect(tp,Card.IsControler,1,1,nil,tp)
		if g:GetCount()>1 and Duel.SelectYesNo(tp,210) then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(99200171,2))
			local g3=g:Select(tp,1,1,g2:GetFirst())
			g2:Merge(g3)
		end
	end
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end
function c99200171.immfilter(e,te)
	return te:IsActiveType(TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c99200171.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c99200171.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c99200171.tg1(e,c)
	return c:IsRace(RACE_MACHINE)
end