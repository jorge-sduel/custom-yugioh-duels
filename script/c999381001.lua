--Greenwood Levia
local s,id=GetID()
function s.initial_effect(c)
	--place
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(65017789,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.tftg)
	e1:SetOperation(s.tfop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function s.rvfilter(c)
	if not c.rune_parameters or not c:IsType(TYPE_RUNE) then return false end
	local f1=c.rune_parameters[6]
	if c.ex_rune_parameters then
		local f2=c.ex_rune_parameters[6]
		return Duel.IsExistingMatchingCard(s.tffilter,tp,LOCATION_DECK,0,1,nil,f1,f2)
	else return Duel.IsExistingMatchingCard(s.tffilter,tp,LOCATION_DECK,0,1,nil,f1,aux.TRUE) end
end
function s.tffilter(c,f1,f2)
	return bit.band(c:GetType(),0x20004)==0x20004 and not c:IsForbidden() and (not f1 or f1(c) or not f2 or f2(c))
end
function s.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.rvfilter,tp,LOCATION_DECK,0,1,nil) end
end
function s.tfop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,s.rvfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	local sc=g:GetFirst()
	if sc then
		--Get Functions
		local f1=sc.rune_parameters[6]
		if sc.ex_rune_parameters then local f2=sc.ex_rune_parameters[6]
		else local f2=aux.TRUE end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		--Place on Field
		local tc=Duel.SelectMatchingCard(tp,s.tffilter,tp,LOCATION_DECK,0,1,1,nil,f1,f2):GetFirst()
		if tc then
			local c=e:GetHandler()
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetValue(RESET_TURN_SET)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			if tc:IsType(TYPE_TRAPMONSTER) then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
				e3:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e3)
			end
		end
	end
end
