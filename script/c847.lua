--
local s,id=GetID()
function s.initial_effect(c)
	--Xyz Summon
	Xyz.AddProcedure(c,nil,4,3,s.xyzfilter,aux.Stringid(id,0))
	c:EnableReviveLimit()
--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetCondition(s.dircon)
	c:RegisterEffect(e2)
end
s.xyz_number=106
function s.xyzfilter(c,tp,xyzc)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		local ag=g:GetMaxGroup(Card.GetAttack)
	return c:IsFaceup() and  c:IsType(TYPE_XYZ,xyzc,SUMMON_TYPE_XYZ,tp) and c:IsAttack(ag:GetAttack())
end
function s.dircon(e)
	return e:GetHandler():GetOverlayCount()>0
end
