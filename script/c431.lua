--Lindrack
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,s.xyzfilter,nil,2,nil,nil,nil,nil,false)
	--custom xyz summoning
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(302,0))
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.xyzcon)
	e0:SetOperation(s.xyzop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--opponent's turn xyz
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(302,1))
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMING_MAIN_END)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.syntg)
	e1:SetOperation(s.synop)
	c:RegisterEffect(e1)
	--change lp
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(s.lpcost)
	--e2:SetCondition(s.lpcon)
	e2:SetOperation(s.lpop)
	c:RegisterEffect(e2)
	--level
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	--e3:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER))
	e3:SetValue(s.atkfilter)
	c:RegisterEffect(e3)
end
function s.atkfilter(e,c)
	return e:GetHandler():GetAttack()*-1 
end
function s.xyzfilter(c,xyz,sumtype,tp)
	return (c:IsType(TYPE_LINK,xyz,sumtype,tp) and c:IsAttribute(ATTRIBUTE_LIGHT,xyz,sumtype,tp)) or (c:IsType(TYPE_XYZ,xyz,sumtype,tp) and c:IsAttribute(ATTRIBUTE_DARK,xyz,sumtype,tp))
end
function s.spfilter1(c,tp)
	return (c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_DARK)) or (c:IsType(TYPE_LINK) and c:IsAttribute(ATTRIBUTE_LIGHT)) 
end
function s.xyzcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp,tp,c)>0
		and Duel.IsExistingMatchingCard(s.spfilter1,tp,LOCATION_GRAVE+LOCATION_MZONE,0,2,nil,tp)
end
function s.xyzop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectMatchingCard(tp,s.spfilter1,tp,LOCATION_GRAVE+LOCATION_MZONE,0,2,2,nil,tp)
	c:SetMaterial(g1)
	Duel.Overlay(c,g1)
end
function s.syntg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsXyzSummonable(nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_EXTRA)
end
function s.synop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.XyzSummon(tp,c,nil)
	end
end
function s.lpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,4000)
	Duel.SetLP(1-tp,4000)
end
