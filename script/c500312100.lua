--Gaia, the Lightning Dragon Champion
local cid,id=GetID()
function cid.initial_effect(c)
cid.Is_Evolute=true
if not EVOLUTE_IMPORTED then Duel.LoadScript("proc_evolute.lua") end
	--c:EnableCounterPermit(0x88)
	c:EnableReviveLimit()
	Evolute.AddProcedure(c,nil,2,99)
 --pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e1)
 --remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(cid.rmcost)
	e2:SetTarget(cid.rmtg)
	e2:SetOperation(cid.rmop)
	c:RegisterEffect(e2)
   --special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCondition(cid.hspcon)
	e3:SetOperation(cid.hspop)
	e3:SetValue(SUMMON_TYPE_EVOLUTE)
	c:RegisterEffect(e3)   
end
function cid.spfilter(c)
	return c:IsFaceup() and c.Is_Evolute and (c:GetLevel()==5 or c:GetLevel()==6 )
end
function cid.hspcon(e,c)
  if c==nil then return true end
	if chk==0 then return true end --Duel.GetFlagEffect(tp,id)==0 end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cid.spfilter,tp,LOCATION_MZONE,0,1,nil)
		
end
function cid.hspop(e,tp,eg,ep,ev,re,r,rp,c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_MATERIAL)
	local g=Duel.SelectMatchingCard(tp,cid.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
		c:SetMaterial(g)
   Duel.SendtoGrave(g,REASON_MATERIAL+REASON_EVOLUTE)
	--Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
function cid.cfilter(c)
	return not c:IsStatus(STATUS_BATTLE_DESTROYED)
end

function cid.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetAttackAnnouncedCount()==0 and Duel.CheckReleaseGroup(tp,cid.cfilter,1,e:GetHandler()) and e:GetHandler():IsCanRemoveCounter(tp,0x111f,3,REASON_COST)  end
 local g=Duel.SelectReleaseGroup(tp,cid.cfilter,1,1,e:GetHandler())
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1,true)
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
 Duel.Release(g,REASON_COST)
 e:GetHandler():RemoveCounter(tp,0x111f,3,REASON_COST)
end
function cid.filter(c)
	return c:IsFaceup() 
end
function cid.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and cid.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cid.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cid.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,1-tp,LOCATION_ONFIELD)
end
function cid.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
