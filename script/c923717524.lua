--Purmpince of Ghosts
c923717524.Is_Runic=true
if not RUNIC_IMPORTED then Duel.LoadScript("proc_runic.lua") end
function c923717524.initial_effect(c)
	c:EnableCounterPermit(0x2f,LOCATION_MZONE)
	--Rune Summon
	c:EnableReviveLimit()
	Runic.AddProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),c923717524.filter,1,1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(17601919,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetTarget(c923717524.addct)
	e2:SetOperation(c923717524.addc)
	c:RegisterEffect(e2)
	--addown
	local e3=Effect.CreateEffect(c)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetValue(c923717524.adval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--addown
	local e5=Effect.CreateEffect(c)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetValue(c923717524.adval2)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e6)
end
function c923717524.filter(c)
	return c:IsCode(17601919) and c:IsLocation(LOCATION_SZONE)
end

function c923717524.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0x2f)
end
function c923717524.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x2f,2)
	end
end
function c923717524.adval(e,c)
	return e:GetHandler():GetCounter(0x2f)*300
end
function c923717524.adval2(e,c)
	return e:GetHandler():GetCounter(0x2f)*-300
end
