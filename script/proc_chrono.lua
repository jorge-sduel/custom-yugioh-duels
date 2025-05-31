
--Constants
--TYPE_CHRONO			= 0x80000000000
--MATERIAL_CHRONO		= 0x40<<32
--REASON_CHRONO			= 0x1600000000000
SUMMON_TYPE_CHRONO	= 0x84000001
--EFFECT_CHRONO_MAT_RESTRICTION		=CODE EFFECT+TYPE_CHRONO
--EFFECT_CANNOT_BE_CHRONO_MATERIAL	=1000
--EFFECT_RUNE_SUBSTITUTE	= CODE EFFECT

if not aux.ChronoProcedure then
	aux.ChronoProcedure = {}
	Chrono = aux.ChronoProcedure
end
if not Chrono then
	Chrono = aux.ChronoProcedure
end
--Procedure Functions
function Chrono.AddProcedure(c,loc)
	if loc==nil then loc=LOCATION_HAND end
	--[[if c.bigbang_type==nil then
		local mt=c:GetMetatable()
		mt.bigbang_type=1
		mt.bigbang_parameters={c,f,min,max,control,location,operation}
	end]]
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetDescription(268,0)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(loc)
	e1:SetCondition(Chrono.Condition(loc))
	--e1:SetTarget(Chrono.Target(loc))
	--e1:SetOperation(Chrono.Operation(loc))
    e1:SetValue(SUMMON_TYPE_CHRONO)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(87102774,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_CONTINUOUS)
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(loc)
	e2:SetCountLimit(1)
	e2:SetCondition(Chrono.reccon)
	e2:SetCost(Chrono.reccost)
	e2:SetTarget(Chrono.rectg)
	e2:SetOperation(Chrono.recop)
	c:RegisterEffect(e2)
end
function Chrono.Condition(loc)
	return	function(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and c:GetTurnCounter()>=e:GetHandler():GetLevel() and  c:IsPublic() 
		end
end		
function Chrono.reccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function Chrono.reccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,99)
	e:GetHandler():RegisterEffect(e1)
end
function Chrono.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
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
	e1:SetCondition(Chrono.discon)
	e1:SetOperation(Chrono.disop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,99)
	e:GetHandler():RegisterEffect(e1)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetCode(1082946)
	e3:SetLabelObject(e1)
	e3:SetOwnerPlayer(tp)
	e3:SetOperation(Chrono.reset)
	e3:SetReset(RESETS_STANDARD_PHASE_END|RESET_OPPO_TURN,99)
	c:RegisterEffect(e3)
end
function Chrono.reset(e,tp,eg,ep,ev,re,r,rp)
	Chrono.disop(e:GetLabelObject(),tp,eg,ep,ev,e,r,rp)
end
function Chrono.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	e:GetHandler():SetTurnCounter(0)
end 
function Chrono.discon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function Chrono.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()+1
	e:GetHandler():SetTurnCounter(ct)
	e:SetLabel(ct)
	if not c:IsLocation(LOCATION_HAND) then
			e:GetHandler():SetTurnCounter(0)
		c:ResetFlagEffect(1082946)
		if re then re:Reset() end
	end
end
