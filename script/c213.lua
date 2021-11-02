--RUM p-force
function c213.initial_effect(c)
--pendulum summon
	Pendulum.AddProcedure(c,false)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(213,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetRange(LOCATION_HAND)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(1160)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c213.target)
	e1:SetOperation(c213.activate)
	c:RegisterEffect(e1)
--Reduce damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(213,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(c213.rdcon)
	e3:SetOperation(c213.rdop)
	c:RegisterEffect(e3)
	--indes
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_TYPE_SINGLE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_CHANGE_LEVEL)
	e6:SetValue(2)
	c:RegisterEffect(e6)
end
c213.pendulum_level=2
function c213.filter1(c,e,tp)
	local rk=c:GetRank()
	if not c:IsType(TYPE_XYZ) or rk<=0 then return false end
	if c:IsLocation(LOCATION_GRAVE|LOCATION_EXTRA) then
		return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	else
		return c:IsFaceup() and Duel.IsExistingMatchingCard(c213.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c,rk)
	end
		
end
function c213.filter2(c,e,tp,mc,rk)
	return c:IsType(TYPE_XYZ) and mc:IsCanBeXyzMaterial(c) 
		and c:GetRank()==rk+1 or c:GetRank()==rk+2 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c213.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return
Duel.IsExistingTarget(c213.filter1,tp,LOCATION_MZONE|LOCATION_GRAVE|LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c213.filter1,tp,LOCATION_MZONE|LOCATION_GRAVE|LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetFirst():IsLocation(LOCATION_MZONE) then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	else
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE|LOCATION_EXTRA)
	end
end
function c213.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local reqxyz=false
	if not tc then return end
	if tc:IsLocation(LOCATION_MZONE) then
		if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
		reqxyz=true
	else
		if not tc:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 
			or tc:IsHasEffect(EFFECT_NECRO_VALLEY) then return end
		if Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			Duel.SpecialSummonComplete()
		end
	end
	local sg=Duel.GetMatchingGroup(c213.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,tc,tc:GetRank())
	if sg:GetCount()>0 and (reqxyz or Duel.SelectYesNo(tp,aux.Stringid(73988674,2))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=sg:Select(tp,1,1,nil):GetFirst()
		if sc then
			local mg=tc:GetOverlayGroup()
			if mg:GetCount()~=0 then
				Duel.Overlay(sc,mg)
			end
			mg:AddCard(tc)
			sc:SetMaterial(mg)
			Duel.Overlay(sc,Group.FromCards(tc))
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
	local c=e:GetHandler()
		Duel.SendtoExtraP(c,tp,REASON_EFFECT)
Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
function c213.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	return ep==tp and tc and tc:IsType(TYPE_XYZ) and Duel.GetFlagEffect(tp,213)==0
end
function c213.rdop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,213)~=0 then return end
	if Duel.SelectYesNo(tp,aux.Stringid(213,2)) then
		Duel.RegisterFlagEffect(tp,213,RESET_PHASE+PHASE_END,0,1)
		Duel.ChangeBattleDamage(tp,0)
	end
end
