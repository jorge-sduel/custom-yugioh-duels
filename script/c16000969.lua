--Cybersian Judgeman
function c16000969.initial_effect(c)
c16000969.IsEvolute=true
if not EVOLUTE_IMPORTED then Duel.LoadScript("proc_evolute.lua") end
	--c:EnableCounterPermit(0x88)
	c:EnableReviveLimit()
	Evolute.AddProcedure(c,c16000969.filter1,2,99,c16000969.rcheck)  
  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16000969,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,0x11e0)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c16000969.cost)
	e1:SetTarget(c16000969.target)
	e1:SetOperation(c16000969.operation)
	c:RegisterEffect(e1) 
 	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_LEAVE_FIELD_P)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetOperation(c16000969.checkop)
	c:RegisterEffect(e0)
 local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16000969,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabelObject(e0)
	e3:SetCondition(c16000969.sccon)
	e3:SetOperation(c16000969.scop)
	c:RegisterEffect(e3)
end
function c16000969.filter1(c,ec,tp)
	return c:IsRace(RACE_SPELLCASTER) or c:IsAttribute(ATTRIBUTE_EARTH)
end
function c16000969.rcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_EARTH)
		and g:IsExists(Card.IsRace,1,nil,RACE_SPELLCASTER)
end
function c16000969.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
		 if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x111f,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x111f,3,REASON_COST)
	--local e1=Effect.CreateEffect(c)
  --  e1:SetType(EFFECT_TYPE_FIELD)
   -- e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
   -- e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
  --  e1:SetReset(RESET_PHASE+PHASE_END)
  --  e1:SetLabelObject(c)
  --  e1:SetTargetRange(1,0)
  --  e1:SetTarget(c50031569.splimit)
   -- Duel.RegisterEffect(e1,tp)
end
function c16000969.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function c16000969.operation(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	e:GetHandler():SetHint(CHINT_CARD,ac)
	--forbidden
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_FORBIDDEN)
	e1:SetTargetRange(0x7f,0x7f)
	e1:SetTarget(c16000969.bantg)
	e1:SetLabel(ac)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,2)
	Duel.RegisterEffect(e1,tp)
end
function c16000969.bantg(e,c)
	return c:IsCode(e:GetLabel())
end
function c16000969.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetCounter(0x111f)>=1 then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c16000969.sccon2(e,tp,eg,ep,ev,re,r,rp)
 local c=e:GetHandler()
	 return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and  e:GetLabelObject():GetLabel()==1
end
function c16000969.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c16000969.sccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_BATTLE) or (c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT+REASON_COST))) and e:GetHandler():IsPreviousPosition(POS_FACEUP)  and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD) and  e:GetLabelObject():GetLabel()==1
end
function c16000969.scop(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.FilterFaceupFunction(c16000969.filter),tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(16000970)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		tc:RegisterEffect(e1)
	end
end
