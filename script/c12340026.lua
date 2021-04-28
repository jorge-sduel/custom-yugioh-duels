--External Worlds Xyz Rank 12
--Scripted by Secuter
function c12340026.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,12,2)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(1)
	e1:SetCondition(c12340026.incond)
	c:RegisterEffect(e1)
	--banish
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340026,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c12340026.cost)
	e2:SetTarget(c12340026.target)
	e2:SetOperation(c12340026.operation)
	c:RegisterEffect(e2)
end

function c12340026.incond(e)
	return e:GetHandler():GetOverlayCount()>0
end

function c12340026.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c12340026.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c12340026.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end