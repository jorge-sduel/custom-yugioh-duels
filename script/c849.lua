--Rxyz
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,7,3,nil,nil,99)
	c:EnableReviveLimit()
	--Detach Xyz material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	--e1:SetCountLimit(1)
	--e1:SetCost(s.cost)
	e1:SetCondition(s.codisable)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(s.spcon)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--Special summon itself from GY
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
	e3:SetCondition(s.spcon1)
	e3:SetTarget(s.sptg1)
	e3:SetOperation(s.spop1)
	c:RegisterEffect(e3)
end
s.listed_series={SET_NUMBER}
function s.cfilter(c)
	return c:IsSetCard(SET_NUMBER) and c:IsCanBeXyzMaterial()
end
function s.codisable(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_CHAINING)
end 
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,3,nil)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_MZONE,0,3,99,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	og=Group.CreateGroup()
	og:Merge(g1)
		if #g1>0 then
		--[[local mg1=g1:GetOverlayGroup()
		if mg1:GetCount()~=0 then
			og:Merge(mg1)
			Duel.Overlay(c,mg1)
		end]]
		c:SetMaterial(g1)
		Duel.Overlay(c,g1)
	end
end
function s.op(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local m = e:GetHandler():GetOverlayGroup():Select(tp,1,1,nil)
	local tc = m:GetFirst();
	if tc:IsMonster() then
	e:SetLabel(1)
	local code=tc:GetOriginalCodeRule()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE&~RESET_TOFIELD)
	e1:SetValue(tc:GetAttack())
	e1:SetReset(RESET_EVENT|RESETS_STANDARD)
	e:GetHandler():RegisterEffect(e1)
	e:GetHandler():CopyEffect(code,RESET_EVENT|RESETS_STANDARD,1)
	else
		e:SetLabel(0)
	end
	Duel.SendtoGrave(m,REASON_COST)
end
function s.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetOverlayCount()>0
end
function s.spfilter1(c)
	return c:IsAbleToRemoveAsCost()
end
function s.removefilter(c)
	return c:IsType(TYPE_XYZ) and c:IsMonster() and c:IsAbleToRemove()
end 
function s.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.removefilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(s.spfilter1,tp,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_ONFIELD+LOCATION_GRAVE,7,nil) end
	local g=Duel.GetMatchingGroup(s.removefilter,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function s.spop1(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.spfilter1,tp,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_ONFIELD+LOCATION_GRAVE,7,7,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local g1=Duel.GetMatchingGroup(s.removefilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
end
