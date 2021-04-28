--Dark Magic Purgatory
function c44782205.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c44782205.condition)
	e1:SetCost(c44782205.cost)
	e1:SetTarget(c44782205.target)
	e1:SetOperation(c44782205.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
c44782205.card_code_list={46986414}
function c44782205.cfilter(c)
	return c:IsFaceup() and c:IsCode(46986414)
end
function c44782205.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c44782205.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c44782205.filter(c)
	return c:IsRace(RACE_SPELLCASTER) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c44782205.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c44782205.filter,1,nil) end
	local g=Duel.SelectReleaseGroup(tp,c44782205.filter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c44782205.atkfilter(c)
	return c:IsPosition(POS_FACEUP_ATTACK)
end
function c44782205.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c44782205.atkfilter,1,nil) end
	Duel.SetTargetCard(eg)
end
function c44782205.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=eg:Filter(c44782205.atkfilter,nil)
	local dg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		local preatk=tc:GetAttack()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(-2000)
		tc:RegisterEffect(e1)
		if preatk~=0 and tc:GetAttack()==0 then dg:AddCard(tc) end
		tc=g:GetNext()
	end
	Duel.Destroy(dg,REASON_EFFECT)
end
