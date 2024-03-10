--
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99,nil,nil,nil,s.matfilter)
	c:EnableReviveLimit()
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(s.matcheck)
	c:RegisterEffect(e2)
end
function s.cfilter(c,sc,tp)
	return c:IsType(TYPE_FUSION,sc,SUMMON_TYPE_SYNCHRO,tp) or c:IsType(TYPE_SYNCHRO,sc,SUMMON_TYPE_SYNCHRO,tp)
end
function s.matfilter(g,sc,tp)
	return g:IsExists(s.cfilter,1,nil,sc,tp)
end
function s.matcheck(e,c)
	local ct=c:GetMaterial()
	if ct:IsExists(Card.IsType,1,nil,TYPE_FUSION) then
		--special summon
	local ae=Effect.CreateEffect(c)
	ae:SetDescription(aux.Stringid(24882256,2))
	ae:SetCategory(CATEGORY_DAMAGE)
	ae:SetType(EFFECT_TYPE_IGNITION)
	ae:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE-RESET_TOFIELD)
	ae:SetCountLimit(1)
	ae:SetRange(LOCATION_MZONE)
	ae:SetOperation(s.spop)
	c:RegisterEffect(ae)
	end
	if ct:IsExists(Card.IsType,1,nil,TYPE_SYNCHRO) then
	--atk down
	
local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE-RESET_TOFIELD)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	end
end
function s.afilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
local dam=Duel.GetMatchingGroup(s.afilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil):GetSum(Card.GetAttack)
	Duel.Damage(1-tp,dam/2,REASON_EFFECT)
end
function s.filter(c)
	return c:IsLocation(LOCATION_ONFIELD)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	Duel.SetChainLimit(s.climit)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function s.climit(e,lp,tp)
	return lp==tp or not e:IsHasType(EFFECT_TYPE_ACTIVATE)
end

