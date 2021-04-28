--ss reforced Battle 
function c257.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetHintTiming(0,TIMING_MAIN_END)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c257.target)
	e1:SetOperation(c257.activate)
	c:RegisterEffect(e1)
end
function c257.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c257.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,511000510,0,0x1,1500,1500,4,0,0) then return end
	c:AddMonsterAttribute(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP)
	if Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP) then
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CHANGE_LEVEL)
	e0:SetValue(4)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetCode(EFFECT_REMOVE_TYPE)
	e1:SetValue(TYPE_TRAP)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_XYZ_LEVEL)
	e3:SetValue(4)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e3)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetReset(RESET_EVENT+0x1fe0000)
	e6:SetCode(EFFECT_ADD_SETCODE)
	e6:SetValue(0x1115)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetReset(RESET_EVENT+0x1fe0000)
	e7:SetCode(EFFECT_ADD_RACE)
	e7:SetValue(RACE_WARRIOR)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetReset(RESET_EVENT+0x1fe0000)
	e8:SetCode(EFFECT_ADD_ATTRIBUTE)
	e8:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e8)
	end
	Duel.SpecialSummonComplete()
end