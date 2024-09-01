--No.s104
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,s.matfilter,4,3,s.ovfilter,aux.Stringid(id,0),3,s.xyzop)
	c:EnableReviveLimit()
	--Attach top deck card during the Standby Phase
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.xyztg)
	e1:SetOperation(s.xyzop1)
	c:RegisterEffect(e1)
	--Attach top deck card during the Standby Phase
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.xyztg1)
	e2:SetOperation(s.xyzop1)
	c:RegisterEffect(e2)
	--Negate activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_HANDES)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,{id,1})
	e3:SetCode(EVENT_CHAINING)
	e3:SetCost(s.cost)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3,false,REGISTER_FLAG_DETACH_XMAT)
	aux.DoubleSnareValidity(c,LOCATION_MZONE)
end
s.xyz_number=104
function s.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE|PHASE_END,0,1)
	return true
end
function s.ovfilter(c,tp,lc)
	return c:IsSetCard(SET_NUMBER) and c:IsType(TYPE_XYZ)
end
function s.matfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK) 
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,3,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,3,3,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev)
		and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.SetLP(1-tp,Duel.GetLP(1-tp)/2)
	end
end
function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0 end
end
function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(1-tp,1):GetFirst() 
	if c:IsRelateToEffect(e) then
	Duel.DisableShuffleCheck()
	if (not g:IsAbleToRemove() or Duel.SelectYesNo(tp,aux.Stringid(id,3))) then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	else
		Duel.Overlay(c,g)
		end
	end
end
function s.xyztg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>0 end
end
function s.xyzop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsSequence,tp,0,LOCATION_DECK,nil,0):GetFirst()
	if c:IsRelateToEffect(e) then
	Duel.DisableShuffleCheck()
	if (not g:IsAbleToRemove() or Duel.SelectYesNo(tp,aux.Stringid(id,3))) then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	else
		Duel.Overlay(c,g)
			end
	end
end
