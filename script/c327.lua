--Armagedon Token
function c327.initial_effect(c)
	--battle
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c327.reptg)
	e5:SetValue(c327.repval)
	e5:SetOperation(c327.repop)
	c:RegisterEffect(e5)
end
function c327.repfilter(c,tp)
	return c:IsFaceup() and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_BATTLE) 
		and not c:IsReason(REASON_REPLACE)
end
function c327.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttack()>=500 and eg:IsExists(c327.repfilter,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(45974017,0))
end
function c327.repval(e,c)
	return c327.repfilter(c,e:GetHandlerPlayer())
end
function c327.repop(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-500)
		c:RegisterEffect(e1)
end

