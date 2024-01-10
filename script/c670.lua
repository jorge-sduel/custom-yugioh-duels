--
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,s.matfilter,1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
		--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCondition(s.atkcon)
	e1:SetValue(s.atkval)
	e1:SetTarget(s.adtg) 
	c:RegisterEffect(e1)
	--ATK up (if normal or special summoned)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(s.atktg2)
	e2:SetOperation(s.atkop2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCondition(s.atkcon2)
	e3:SetValue(s.atkval2)
	e3:SetTarget(s.adtg1)
	c:RegisterEffect(e3)
end
s.material={63977008}
s.listed_names={63977008}
s.material_setcode=0x1017
s.listed_series={0x43}
function s.matfilter(c,scard,sumtype,tp)
	return c:IsSummonCode(scard,sumtype,tp,63977008) or c:IsHasEffect(20932152)
end 
function s.atkcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL
		and e:GetHandler()==Duel.GetAttacker() and Duel.GetAttackTarget()~=nil
end
function s.atkval(e,c)
	return Duel.GetAttackTarget():GetBaseAttack()/2
end
function s.atkcon2(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL
		and e:GetHandler()==Duel.GetAttackTarget()
end
function s.atkval2(e,c)
	return Duel.GetAttacker():GetBaseAttack()/2
end
function s.atkfilter2(c)
	return c:IsSetCard(0x43) and c:IsFaceup()
end
function s.atktg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.atkfilter2,tp,LOCATION_MZONE,0,1,nil) end
end
function s.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local atkval=Duel.GetMatchingGroupCount(s.atkfilter2,tp,LOCATION_MZONE,0,nil)*300
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atkval)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e1)
	end
end
function s.adtg(e,c)
	return c==e:GetHandler():GetBattleTarget()
end
function s.adtg1(e,c)
	return c==Duel.GetAttacker()
end
