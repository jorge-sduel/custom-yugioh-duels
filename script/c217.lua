--syn xyz supreme king
if not EVOLUTE_IMPORTED then Duel.LoadScript("proc_evolute.lua") end
function c217.initial_effect(c)
	c:EnableReviveLimit()
	--synchro summon
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTunerEx(Card.IsType,TYPE_SYNCHRO),1,99,c217.sssmatfilter)
	c:EnableReviveLimit()
	--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(80896940,1))
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	e0:SetCondition(XyzSyn.con)
	e0:SetOperation(XyzSyn.op)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(80896940,1))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	e1:SetCondition(c217.sprcon)
	e1:SetOperation(c217.sprop)
	c:RegisterEffect(e1)
	--add effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c217.tncon)
	e2:SetOperation(c217.tnop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c217.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(82044279,0))
	e4:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c217.condition)
	e4:SetTarget(c217.target)
	e4:SetOperation(c217.operation)
	c:RegisterEffect(e4)
	--negate spell
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(67000071,0))
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c217.negcon)

	e5:SetTarget(c217.negtg)
	e5:SetOperation(c217.negop)
	c:RegisterEffect(e5)
	--negate trap
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(67000071,0))
	e6:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c217.negcon2)

	e6:SetTarget(c217.negtg)
	e6:SetOperation(c217.negop)
	c:RegisterEffect(e6)
	--Special summon
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(4796100,0))
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetTarget(c217.sptg)
	e7:SetOperation(c217.spop)
	c:RegisterEffect(e7)
	--material
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetRange(LOCATION_GRAVE)
	e8:SetCost(aux.bfgcost)
	e8:SetTarget(c217.mattg)
	e8:SetOperation(c217.matop)
	c:RegisterEffect(e8)
end
c217.material_type=TYPE_SYNCHRO

function c217.sssmatfilter(c)
	return c:IsType(TYPE_XYZ)
end
function c217.rcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsType,1,nil,TYPE_XYZ)
		and g:IsExists(CARD.IsType,1,nil,TYPE_SYNCHRO)
end
function c217.sfilter(c,tp,sc)
	local rg=Duel.GetMatchingGroup(c217.pfilter,tp,LOCATION_MZONE,0,c)
	return c:IsType(TYPE_SYNCHRO) and c:IsReleasable() and c:IsLevelBelow(2147483647)
		and rg:IsExists(c217.filterchk,1,nil,rg,Group.CreateGroup(),tp,c,sc)
end
function c217.pfilter(c)
	return c:IsLevelBelow(2147483647) and c:IsType(TYPE_XYZ) and c:IsReleasable()
end
function c217.filterchk(c,g,sg,tp,sync,sc)
	sg:AddCard(c)
	sg:AddCard(sync)
	local res=Duel.GetLocationCountFromEx(tp,tp,sg,sc)>0 
		and sg:CheckWithSumEqual(Card.GetLevel,11,#sg,#sg)
	sg:RemoveCard(sync)
	if not res then
		res=g:IsExists(c217.filterchk,1,sg,g,sg,tp,sync,sc)
	end
	sg:RemoveCard(c)
	return res
end
function c217.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c217.sfilter,tp,LOCATION_MZONE,0,1,nil,tp,c)
end
function c217.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c217.sfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
	local sync=g:GetFirst()
	local rg=Duel.GetMatchingGroup(c217.pfilter,tp,LOCATION_MZONE,0,sync)
	local tc
	local mg=Group.CreateGroup()
	while true do
		local tg=rg:Filter(c217.filterchk,mg,rg,mg,tp,sync,c)
		if #tg<=0 then break end
		mg:AddCard(sync)
		local cancel=#mg>1 and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0 
			and mg:CheckWithSumEqual(Card.GetLevel,11,#mg,#mg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		tc=Group.SelectUnselect(tg,mg,tp,cancel,cancel)
		if not tc then break end
		mg:RemoveCard(sync)
		if tc~=sync then
			if mg:IsContains(tc) then
				mg:RemoveCard(tc)
			else
				mg:AddCard(tc)
			end
		end
	end
	mg:Merge(g)
	Duel.Release(mg,REASON_COST)
	local c=e:GetHandler()

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c217.atkcon)
	e1:SetValue(c217.atkval)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c217.distg)
	c:RegisterEffect(e2)
end
function c217.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsType,1,nil,TYPE_XYZ) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c217.tncon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()==1
end
function c217.tnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c217.atkcon)
	e1:SetValue(c217.atkval)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c217.distg)
	c:RegisterEffect(e2)
end
function c217.atkcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL
		and e:GetHandler()==Duel.GetAttacker() and Duel.GetAttackTarget()~=nil
end
function c217.atkval(e,c)
	return math.ceil(Duel.GetAttackTarget():GetAttack()/2)
end
function c217.distg(e,c)
	local uc=e:GetHandler()
	if Duel.GetAttacker()==uc then
		return Duel.GetAttackTarget()==c
	elseif Duel.GetAttackTarget()==uc then
		return Duel.GetAttacker()==c
	else return false end
end
function c217.condition(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c217.cfilter(c)
	return c:IsLocation(LOCATION_MZONE)
end
function c217.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local g=Group.CreateGroup()
		for i=1,ev do
			local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
			local tc=te:GetHandler()
			if tc and tc:IsCanBeEffectTarget(e) and te:IsActiveType(TYPE_MONSTER) then
				local loc=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_LOCATION)
				if tc:IsType(TYPE_MONSTER) and loc==LOCATION_MZONE then g:AddCard(tc) end
				if te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
					local tg=Duel.GetChainInfo(i,CHAININFO_TARGET_CARDS)
					if tg and tg:IsExists(c217.cfilter,1,nil) then g:AddCard(tc) end
				end
			end
		end
		return g:IsContains(chkc) end
	if chk==0 then
		local g=Group.CreateGroup()
		for i=1,ev do
			local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
			local tc=te:GetHandler()
			if tc and tc:IsCanBeEffectTarget(e) and te:IsActiveType(TYPE_MONSTER) then
				local loc=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_LOCATION)
				if tc:IsType(TYPE_MONSTER) and loc==LOCATION_MZONE then g:AddCard(tc) end
				if te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
					local tg=Duel.GetChainInfo(i,CHAININFO_TARGET_CARDS)
					if tg and tg:IsExists(c217.cfilter,1,nil) then g:AddCard(tc) end
				end
			end
		end
		return g:GetCount()>0 end
	local g=Group.CreateGroup()
	for i=1,ev do
		local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
		local tc=te:GetHandler()
		if tc and tc:IsCanBeEffectTarget(e) and te:IsActiveType(TYPE_MONSTER) then
			local loc=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_LOCATION)
			local check=false
			if tc:IsType(TYPE_MONSTER) and loc==LOCATION_MZONE then g:AddCard(tc) end
			if te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
				local tg=Duel.GetChainInfo(i,CHAININFO_TARGET_CARDS)
				if tg and tg:IsExists(c217.cfilter,1,nil) then g:AddCard(tc) end
			end
			if check then tc:RegisterFlagEffect(217,RESET_CHAIN,0,1,i) end
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=g:Select(tp,1,1,nil)
	Duel.SetTargetCard(sg)
	local i=sg:GetFirst():GetFlagEffectLabel(217)
	local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,sg,1,0,0)
	if sg:GetFirst():IsRelateToEffect(te) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,1,0,0)
	end
end
function c217.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or tc:IsDisabled() then return end
	Duel.NegateRelatedChain(tc,RESET_TURN_SET)
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
	local e3
	if tc:IsType(TYPE_TRAPMONSTER) then
		e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e3)
	end
	local i=tc:GetFlagEffectLabel(217)
	local te=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT)
	if not tc:IsImmuneToEffect(e1) and not tc:IsImmuneToEffect(e2) and (not e3 or not tc:IsImmuneToEffect(e3)) and tc:IsRelateToEffect(te) 
		and Duel.Destroy(tc,REASON_EFFECT)>0 and c:IsRelateToEffect(e) and c:IsFaceup() then
		local atk=tc:GetTextAttack()
		if atk<=0 then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c217.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return re:IsActiveType(TYPE_SPELL) and Duel.IsChainNegatable(ev)
end
function c217.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c217.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c217.negcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return re:IsActiveType(TYPE_TRAP) and Duel.IsChainNegatable(ev)
end
function c217.spfilter(c,e,tp)
	return (c:IsType(TYPE_XYZ) or c:IsType(TYPE_SYNCHRO)) and not c:IsCode(217) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c217.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c217.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c217.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c217.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c217.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c217.xyzfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c217.matfilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA)) and c:IsCanOverlay()
end
function c217.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c217.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c217.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c217.matfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c217.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c217.matop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c217.matfilter),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,2,2,nil)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end
