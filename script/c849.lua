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
	e1:SetCountLimit(1)
	--e1:SetCost(s.cost)
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
end
s.listed_series={SET_NUMBER}
function s.cfilter(c)
	return c:IsSetCard(SET_NUMBER) and c:IsCanBeXyzMaterial()
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
