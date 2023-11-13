--created by LeonDuvall, coded by Lyris
local cid,id=GetID()
cid.IsTimeleap=true
if not TIMELEAP_IMPORTED then Duel.LoadScript("proc_timeleap.lua") end
function cid.initial_effect(c)
	c:EnableReviveLimit()
	--time leap procedure
Timeleap.AddProcedure(c,cid.matfilter,1,1,cid.timecon)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(2)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCondition(cid.con(0x1cfd))
	e1:SetCost(cid.cost)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetCondition(cid.con(0xcfd))
	e2:SetValue(cid.tglimit)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetTarget(cid.tglimit)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
end
cid.listed_names={id-7}
cid.material={id-7}
function cid.timecon(e)
	return not Duel.IsExistingMatchingCard(cid.confilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) 
end
function cid.confilter(c)
	return c:IsFaceup() and c:IsCode(id)
end
function cid.matfilter(c)
	return c:IsCode(id-7)
end
function cid.con(set)
	return function(e) return Duel.IsExistingMatchingCard(aux.AND(Card.IsFaceup,Card.IsSetCard),e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler(),set) end
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	Duel.Destroy(Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD):Select(tp,1,1,nil),REASON_EFFECT)
end
function cid.tglimit(e,c)
	return c==e:GetHandler()
end
