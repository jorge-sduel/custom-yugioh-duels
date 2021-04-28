--Cfhhf
function c103.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c103.spcon)
	e1:SetOperation(c103.spop)
	c:RegisterEffect(e1)
end
function c103.spcostfilter(c)
	return c:IsReleasable() and c:IsType(TYPE_TUNER+TYPE_MONSTER) and (not c:IsLocation(LOCATION_MZONE) or c:IsFaceup())
end
function c103.spcheck(sg,tp)
	return Duel.GetMZoneCount(tp,sg,tp)>0 and aux.gfcheck(sg,Card.IsType,TYPE_TUNER,TYPE_MONSTER)
end
function c103.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c103.spcostfilter,tp,LOCATION_MZONE,0,c)
	return g:CheckSubGroup(c103.spcheck,2,2,tp)
end
function c103.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c103.spcostfilter,tp,LOCATION_MZONE,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,c103.spcheck,false,2,2,tp)
	Duel.Release(sg,REASON_COST)
end

