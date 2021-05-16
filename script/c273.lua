--chrono
function c273.initial_effect(c)
	c:EnableReviveLimit()
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(87102774,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1)
	e1:SetCondition(c273.reccon)
	e1:SetCost(c273.reccost)
	e1:SetTarget(c273.rectg)
	e1:SetOperation(c273.recop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c273.spcon)
	c:RegisterEffect(e2)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c273.aclimit)
	e3:SetCondition(c273.actcon)
	c:RegisterEffect(e3)
	--change effect
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(71166481,0))
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c273.chcon)
	e4:SetOperation(c273.chop)
	c:RegisterEffect(e4)
end
function c273.reccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c273.reccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,99)
	e:GetHandler():RegisterEffect(e1)
end
function c273.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
	--destroy
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c273.discon)
	e1:SetOperation(c273.disop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,99)
	e:GetHandler():RegisterEffect(e1)
	e:GetHandler():RegisterFlagEffect(1082946,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,99)
	c273[e:GetHandler()]=e1
end
function c273.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
			e:GetHandler():SetTurnCounter(0)
end

function c273.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c273.disop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()+1
	e:GetHandler():SetTurnCounter(ct)
	e:SetLabel(ct)
	if not c:IsLocation(LOCATION_HAND) then
			e:GetHandler():SetTurnCounter(0)
		c:ResetFlagEffect(1082946)
		if re then re:Reset() end
	end
end
function c273.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and c:GetTurnCounter()>=e:GetHandler():GetLevel()
end
function c273.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c273.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
function c273.chcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c273.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c273.repop)
end
function c273.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,2,REASON_EFFECT)
	Duel.Draw(1-tp,2,REASON_EFFECT)
end
