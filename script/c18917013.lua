--Arcanite Magus
local ref=_G['c'..18917013]
ref.IsTimeleap=true
if not TIMELEAP_IMPORTED then Duel.LoadScript("proc_timeleap.lua") end
function ref.initial_effect(c)
	c:EnableReviveLimit()
	  --synchro summon
	--time leap procedure
Timeleap.AddProcedure(c,nil,1,1,ref.TimeCon)
	
	c:EnableCounterPermit(0x1)
	--attackup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(ref.attackup)
	c:RegisterEffect(e1)
	--synchro success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(31924889,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(ref.addcc)
	e2:SetTarget(ref.addct)
	e2:SetOperation(ref.addc)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(31924889,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(ref.rmcost)
	e3:SetTarget(ref.rmtg)
	e3:SetOperation(ref.rmop)
	c:RegisterEffect(e3)
end
function ref.TimeCon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_GRAVE,0,nil)>=4
end

function ref.material(c)
	return c:IsRace(RACE_SPELLCASTER)
end

function ref.attackup(e,c)
	return c:GetCounter(0x1)*1000
end
function ref.addcc(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+269
end
function ref.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0x1)
end
function ref.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x1,2)
	end
end
function ref.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x1,1,REASON_COST)
end
function ref.rmfilter(c)
	return c:IsPosition(POS_ATTACK) and c:IsAbleToRemove()
end
function ref.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(ref.rmfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,ref.rmfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function ref.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsControler(1-tp) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
