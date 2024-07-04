--
local s,id=GetID()
function s.initial_effect(c)
	--Xyz Summon
	Xyz.AddProcedure(c,s.matfilter,4,3,s.xyzfilter,aux.Stringid(id,0),3,s.xyzop)
	c:EnableReviveLimit()
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetCondition(s.dircon)
	c:RegisterEffect(e2)
	--Negate the effects of all face-up cards on the field
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.descon)
	--e3:SetCondition(s.negcon)
	e3:SetOperation(s.negop)
	c:RegisterEffect(e3)
end
s.xyz_number=106
function s.matfilter(c)
	return c:IsRace(RACE_ROCK)
end
function s.xyzfilter(c,tp,xyzc)
	local g=Duel.GetMatchingGroup(s.filterx,tp,LOCATION_MZONE,0,nil)
	return #g>0 and g:GetMaxGroup(Card.GetAttack,nil):IsContains(c)
end
function s.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE|PHASE_END,0,1)
	return true
end
function s.dircon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function s.filterx(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp,chk)
	return ep~=tp
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return (loc&LOCATION_ONFIELD)~=0 and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)<1 then return end
	local g=Duel.GetMatchingGroup(Card.IsNegatable,tp,0,LOCATION_ONFIELD,c)
	g:ForEach(function(tc) tc:NegateEffects(c,RESET_EVENT+RESETS_STANDARD,true) end)
end
	
