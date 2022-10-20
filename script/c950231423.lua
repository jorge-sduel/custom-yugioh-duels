--Abyss Actor - Splendid Heroine
c950231423.Is_Runic=true
if not RUNIC_IMPORTED then Duel.LoadScript("proc_runic.lua") end
function c950231423.initial_effect(c)
	--Rune Summon
	c:EnableReviveLimit()
	Runic.AddProcedure(c,aux.FilterBoolFunction(Card.IsCode,24907044),c950231423.STMatFilter,1,1)
--atk down
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(950231423,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	--e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	--e1:SetCondition(c950231423.atkcon1)
	e1:SetTarget(c950231423.atktg1)
	e1:SetOperation(c950231423.atkop1)
	c:RegisterEffect(e1)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetOperation(c950231423.atkop)
	c:RegisterEffect(e3)
end
function c950231423.STMatFilter(c)
	return c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)
end
function c950231423.atkcon1(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	return ep==tp and a:IsControler(1-tp) and a:IsFaceup() and a:IsRelateToBattle()
end
function c950231423.atktg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c950231423.atkop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if #g>0 then
		local tc=g:GetFirst()
		for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(3000)
		tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e2:SetValue(3000)
			tc:RegisterEffect(e2)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e3)
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_UPDATE_ATTACK)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e4:SetValue(-ev)
			tc:RegisterEffect(e4)
			local e5=e4:Clone()
			e5:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e5)
		end
	end
end
function c950231423.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c950231423.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c950231423.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
