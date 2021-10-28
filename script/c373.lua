--ss synchro
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
 Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99,s.matfilter)
	--quick-play
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
	--Can be treated as a level 3 or 5 for the Xyz summon of a WATER monster
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CHANGE_LEVEL)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetValue(8)
  c:RegisterEffect(e4)
end
function s.matfilter(c,scard,sumtype,tp)
	return c:IsSetCard(0x115,scard,sumtype,tp)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()	
	local g=Duel.GetMatchingGroup(s.spfilter,c:GetControler(),LOCATION_SZONE+LOCATION_HAND,LOCATION_SZONE+LOCATION_HAND,nil)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(id)==0 then
			tc:RegisterFlagEffect(id,EVENT_ADJUST,0,1)
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_ADD_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(TYPE_QUICKPLAY)
			e1:SetReset(RESET_EVENT+EVENT_ADJUST,1)
			tc:RegisterEffect(e1)
			local te=tc:GetActivateEffect()
			if tc:GetFlagEffect(id)==0 and te then
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_QUICK_O)
				e2:SetCode(te:GetCode())
				e2:SetRange(LOCATION_SZONE+LOCATION_HAND)
				e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e2:SetCondition(s.accon)
				if te:GetCost() then
					e2:SetCost(te:GetCost())
				end
				e2:SetTarget(s.actg)
				e2:SetOperation(s.acop)
				tc:RegisterEffect(e2)
				tc:RegisterFlagEffect(id,nil,0,1)
			end
		end
		tc=g:GetNext()
	end		
end
function s.spsan(c)
	return c:IsFaceup() and not c:IsStatus(STATUS_DISABLED) and c:IsCode(id)
end
function s.accon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local c=e:GetHandler()
	local te=c:GetActivateEffect()
	return  Duel.IsExistingMatchingCard(s.spsan,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil)
		and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function s.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local con=false
	if Duel.GetTurnPlayer()~=c:GetControler() then
		con=not c:IsStatus(STATUS_SET_TURN) and c:IsFacedown()
	else
		if Duel.GetCurrentChain()>0 or not (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2) then
			if c:IsLocation(LOCATION_HAND) then
				con=(Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or c:IsType(TYPE_FIELD))
			elseif c:IsLocation(LOCATION_SZONE) then
				con=not c:IsStatus(STATUS_SET_TURN) and c:IsFacedown()
			end
		end
	end
	local te=c:GetActivateEffect()
	local target=te:GetTarget()
	local tpe=c:GetType()
	if chk==0 then return con and (not target or target(te,tp,eg,ep,ev,re,r,rp,0)) end
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	if bit.band(tpe,TYPE_FIELD)~=0 then
		local of=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
		if of and Duel.Destroy(of,REASON_RULE)==0 and Duel.SendtoGrave(of,REASON_RULE)==0 then Duel.SendtoGrave(c,REASON_RULE) end
	end
	if c:IsLocation(LOCATION_ONFIELD) and c:IsFacedown() then
		Duel.ChangePosition(c,POS_FACEUP)
	else
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
	c:CreateEffectRelation(te)
	if target then target(te,tp,eg,ep,ev,re,r,rp,1) end			
end
function s.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=c:GetActivateEffect()
	local op=te:GetOperation()
	local tpe=c:GetType()
	if op then
		c:CreateEffectRelation(te)
		if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)==0 then
			c:CancelToGrave(false)
		end
		c:ReleaseEffectRelation(te)
		if op then op(te,tp,eg,ep,ev,re,r,rp) end
	end
end
