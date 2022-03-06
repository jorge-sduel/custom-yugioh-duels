--Pandelumiere Cartografo
--Scripted by: XGlitchy30
local cid,id=GetID()
cid.IsEquilibrium=true
if not EQUILIBRIUM_IMPORTED then Duel.LoadScript("proc_equilibrium.lua") end
function cid.initial_effect(c)
  Equilibrium.AddProcedure(c)
	--MONSTER EFFECTS
--destroy and spsummon
	local p1=Effect.CreateEffect(c)
	p1:SetDescription(aux.Stringid(id,0))
	p1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	p1:SetType(EFFECT_TYPE_QUICK_O)
	p1:SetRange(LOCATION_PZONE)
	p1:SetCode(EVENT_FREE_CHAIN)
	p1:SetCountLimit(1)
	p1:SetCondition(cid.dpcon)
	p1:SetTarget(cid.dptg)
	p1:SetOperation(cid.dpop)
	c:RegisterEffect(p1)
	--protection
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetTarget(cid.tgtg)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--add to hand
	-- local e2=Effect.CreateEffect(c)
	-- e2:SetDescription(aux.Stringid(id,1))
	-- e2:SetCategory(CATEGORY_DESTROY)
	-- e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	-- e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	-- e2:SetCode(EVENT_DESTROYED)
	-- e2:SetCountLimit(1,id)
	-- e2:SetTarget(cid.placetg)
	-- e2:SetOperation(cid.placeop)
	-- c:RegisterEffect(e2)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,id)
	e2:SetTarget(cid.placetg)
	e2:SetOperation(cid.placeop)
	c:RegisterEffect(e2)
--Activate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCost(cid.cost)
	e4:SetCondition(cid.condition)
	e4:SetTarget(cid.target)
	e4:SetOperation(cid.activate)
	c:RegisterEffect(e4)
--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(97268402,0))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_HAND)
	e5:SetTarget(cid.destarget)
	e5:SetOperation(Equilibrium.desop1)
	c:RegisterEffect(e5)
end
function cid.desfilter(c)
	return c:IsType(TYPE_PENDULUM)
end
function cid.destarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and cid.desfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(cid.filter,tp,LOCATION_PZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cid.desfilter,tp,LOCATION_PZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
--DESTROY AND SPSUMMON
function cid.doubtfilter(c)
	return c:IsFacedown() or c:IsType(TYPE_MONSTER)
end
function cid.dpfilter(c)
	return c:IsFacedown() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
--------
function cid.dpcon(e,tp,eg,ep,ev,re,r,rp)
	return  not Duel.IsExistingMatchingCard(cid.doubtfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cid.dptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cid.dpfilter,tp,LOCATION_SZONE,0,1,e:GetHandler())
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPE_MONSTER+TYPE_EFFECT,2000,0,4,RACE_THUNDER,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE)
	end
	local g=Duel.GetMatchingGroup(cid.dpfilter,tp,LOCATION_SZONE,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cid.dpop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,cid.dpfilter,tp,LOCATION_SZONE,0,1,1,aux.TRUE)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT)~=0 then
			if not e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP_DEFENSE) or not Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,TYPE_MONSTER+TYPE_EFFECT,2000,0,4,RACE_THUNDER,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE) then return end
			e:GetHandler():AddMonsterAttribute(TYPE_EFFECT)
			Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,false,POS_FACEUP_DEFENSE)
		end
	end
end
--PROTECTION
function cid.tgtg(e,c)
	return c:IsType(TYPE_PENDULUM) or (c:IsLocation(LOCATION_SZONE) and c:GetFlagEffect(726)>0)
end
function cid.eqtg(e,c)
	return c:IsType(TYPE_PENDULUM)
end
--PLACE
function cid.placefilter(c)
	return c:GetSequence()==0 or c:GetSequence()==4
end
function cid.ufilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAbleToHand() and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function cid.ucheck(c,typ)
	return cid.ufilter(c) and (not typ or not c:IsType(typ))
end
-- function cid.pendfilter(c)
	-- return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
-- end
-- function cid.pandfilter(c,e,tp,eg,ep,ev,re,r,rp)
	-- return c.Pandemonium and not c:IsForbidden()
-- end
-- function cid.ufilter(c,tp,ctype,ct,sg,e,eg,ep,ev,re,r,rp)
	-- if not c:IsType(ctype) or c:IsForbidden() or (c.Pandemonium then return false end
	-- sg:AddCard(c)
	-- local typ
	-- if ct<2 then typ=TYPE_PENDULUM else typ=TYPE_PENDULUM end
	-- local res=(ct>=4 or Duel.IsExistingMatchingCard(cid.ufilter,tp,LOCATION_DECK,0,1,sg,tp,typ,ct+1,sg,e,eg,ep,ev,re,r,rp))
	-- sg:RemoveCard(c)
	-- ct=ct-1
	-- return res
-- end
----------
function cid.placetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local sg=Group.CreateGroup()
		return Duel.IsExistingMatchingCard(cid.placefilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil)
		--and Duel.IsExistingMatchingCard(cid.ufilter,tp,LOCATION_DECK,0,1,nil,tp,TYPE_PENDULUM,1,sg,e,eg,ep,ev,re,r,rp)
	end
	local g=Duel.GetMatchingGroup(cid.placefilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function cid.placeop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cid.placefilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	if #g<=0 then return end
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 then
		if Duel.IsExistingMatchingCard(cid.ufilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,TYPE_PENDULUM) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			local group,typ=Group.CreateGroup(),false
			group:KeepAlive()
			for i=1,math.min(ct,2) do
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cid.ucheck),tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,group,typ)
				if #sg>0 then
					typ=bit.band(sg:GetFirst():GetType(),TYPE_PENDULUM)
					group:Merge(sg)
				end
			end
			if #group>0 then
				Duel.SendtoHand(group,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,group)
				local tc=group:GetFirst()
				while tc do
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_FIELD)
					e1:SetCode(EFFECT_CANNOT_SUMMON)
					e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e1:SetTargetRange(1,0)
					e1:SetTarget(cid.sumlimit)
					e1:SetLabel(tc:GetCode())
					e1:SetReset(RESET_PHASE+PHASE_END)
					Duel.RegisterEffect(e1,tp)
					local e2=e1:Clone()
					e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
					Duel.RegisterEffect(e2,tp)
					local e4=e1:Clone()
					e4:SetCode(EFFECT_CANNOT_ACTIVATE)
					e4:SetValue(cid.aclimit)
					Duel.RegisterEffect(e4,tp)
					tc=group:GetNext()
				end
			end
		end
			-- if Duel.CheckLocation(tp,LOCATION_SZONE,0) and Duel.CheckLocation(tp,LOCATION_SZONE,4) and Duel.CheckLocation(1-tp,LOCATION_SZONE,0) and Duel.CheckLocation(1-tp,LOCATION_SZONE,4) then
				-- local exg=Group:CreateGroup()
				-- exg:KeepAlive()
				-- for times=0,1 do
					-- local p
					-- if times==0 then p=tp else p=1-tp end
					-- Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2))
					-- local tc1=Duel.SelectMatchingCard(tp,cid.pendfilter,tp,LOCATION_DECK,0,1,1,exg):GetFirst()
					-- exg:AddCard(tc1)
					-- local tc2=Duel.SelectMatchingCard(tp,cid.pandfilter,tp,LOCATION_DECK,0,1,1,exg,e,p,eg,ep,ev,re,r,rp):GetFirst()
					-- exg:AddCard(tc2)
					-- if not (tc1 and tc2) then return end
					-- Duel.MoveToField(tc1,tp,p,LOCATION_SZONE,POS_FACEUP,true)
					-- aux.PandAct(tc2,p,0x10|0x200)(e,tp,eg,ep,ev,re,r,rp)
					-- local e1=Effect.CreateEffect(e:GetHandler())
					-- e1:SetType(EFFECT_TYPE_SINGLE)
					-- e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
					-- e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					-- e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
					-- e1:SetValue(LOCATION_REMOVED)
					-- tc1:RegisterEffect(e1,true)
					-- local e2=Effect.CreateEffect(e:GetHandler())
					-- e2:SetType(EFFECT_TYPE_SINGLE)
					-- e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
					-- e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					-- e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
					-- e2:SetValue(LOCATION_REMOVED)
					-- tc2:RegisterEffect(e2,true)
				-- end
			-- end
	end
end
function cid.sumlimit(e,c)
	return c:IsCode(e:GetLabel())
end
function cid.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel()) and not re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cid.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetBattleDamage(tp)>=2000
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,4000)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,4000,REASON_EFFECT)
end
