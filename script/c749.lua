--フォース
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsFaceup()
end
function s.xyzfilter(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.xyzfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.xyzfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		--local sc=tc2:Select(tp,1,1,nil)
		--local tc3=tc2:GetFirst()
		if tc:IsType(TYPE_SYNCHRO) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		--e1:SetCondition(function(e,tc) return tc:IsType(TYPE_SYNCHRO) end)
		e1:SetValue(4)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SYNCHRO_LEVEL)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		--e2:SetCondition(function(e,tc) return tc:IsType(TYPE_SYNCHRO) end)
		e2:SetValue(s.synval)
		tc:RegisterEffect(e2)
		else
		if tc:IsType(TYPE_XYZ) then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_RANK_LEVEL)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		--e3:SetCondition(function(e,tc) return tc:IsType(TYPE_XYZ) end)
		tc:RegisterEffect(e3)
		local e12=Effect.CreateEffect(e:GetHandler())
		e12:SetType(EFFECT_TYPE_SINGLE)
		e12:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
		--e12:SetCondition(function(e,tc) return tc:IsType(TYPE_XYZ) end)
		e12:SetValue(7)
		e12:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e12)
		else
		if tc:IsType(TYPE_FUSION) then
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_CHANGE_LEVEL)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		--e4:SetCondition(function(e,tc) return tc:IsType(TYPE_FUSION) end)
		e4:SetValue(8)
		tc:RegisterEffect(e4)
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_ADD_TYPE)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		--e5:SetCondition(function(tc) return tc:IsType(TYPE_FUSION) end)
		e5:SetValue(TYPE_TUNER)
		tc:RegisterEffect(e5)
				end
			end
		end
	end
		local tc3=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,tc):GetFirst() 
		--if tc3 and tc3:IsRelateToEffect(e) and tc3:IsFaceup() then
		--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		if tc3:IsType(TYPE_SYNCHRO) then
		local e6=Effect.CreateEffect(e:GetHandler())
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_CHANGE_LEVEL)
		e6:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		--e6:SetCondition(function(tc) return tc:IsType(TYPE_SYNCHRO) end)
		e6:SetValue(4)
		tc3:RegisterEffect(e6)
		local e7=Effect.CreateEffect(e:GetHandler())
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetCode(EFFECT_SYNCHRO_LEVEL)
		e7:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		--e7:SetCondition(function(tc) return tc:IsType(TYPE_SYNCHRO) end)
		e7:SetValue(s.synval)
		tc3:RegisterEffect(e7)
		else
		if tc:IsType(TYPE_XYZ) then
		local e8=Effect.CreateEffect(e:GetHandler())
		e8:SetType(EFFECT_TYPE_SINGLE)
		e8:SetCode(EFFECT_RANK_LEVEL)
		e8:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		--e8:SetCondition(function(tc) return tc:IsType(TYPE_XYZ) end)
		tc3:RegisterEffect(e8)
		local e11=Effect.CreateEffect(e:GetHandler())
		e11:SetType(EFFECT_TYPE_SINGLE)
		e11:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
		--e11:SetCondition(function(tc) return tc:IsType(TYPE_XYZ) end)
		e11:SetValue(7)
		e11:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc3:RegisterEffect(e11)
		else
		if tc:IsType(TYPE_FUSION) then
		local e9=Effect.CreateEffect(e:GetHandler())
		e9:SetType(EFFECT_TYPE_SINGLE)
		e9:SetCode(EFFECT_CHANGE_LEVEL)
		e9:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		--e9:SetCondition(function(tc) return tc:IsType(TYPE_FUSION) end)
		e9:SetValue(8)
		tc3:RegisterEffect(e9)
		local e10=Effect.CreateEffect(e:GetHandler())
		e10:SetType(EFFECT_TYPE_SINGLE)
		e10:SetCode(EFFECT_ADD_TYPE)
		e10:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		--e10:SetCondition(function(tc) return tc:IsType(TYPE_FUSION) end)
		e10:SetValue(TYPE_TUNER)
		tc3:RegisterEffect(e10)	
		--		end
			end
		end
	end
end
function s.synval(e,c)
	local lv=e:GetHandler():GetLevel()
	return 2*65536+lv
end
