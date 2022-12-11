--Blazedrive Evobeast
local ref=_G['c'..28915104]
local id=28915104
function ref.initial_effect(c)
	--Evolute Summon
ref.Is_Evolute=true
if not EVOLUTE_IMPORTED then Duel.LoadScript("proc_evolute.lua") end
	--c:EnableCounterPermit(0x88)
	c:EnableReviveLimit()
	--Convergent Evolute
aux.AddConvergentEvolSummonProcedure(c,ref.matfilter1,LOCATION_ONFIELD)
	--Nontarget
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	--Removal
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(ref.tgcost)
	e2:SetTarget(ref.tgtg)
	e2:SetOperation(ref.tgop)
	c:RegisterEffect(e2)
--
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e10:SetCode(EFFECT_ALLOW_NEGATIVE)
	c:RegisterEffect(e10)
	--spsummon
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e12:SetCode(EFFECT_SPSUMMON_PROC)
	e12:SetRange(LOCATION_EXTRA)
	e12:SetValue(SUMMON_TYPE_EVOLUTE)
	e12:SetCondition(ref.hspcon)
	e12:SetTarget(ref.hsptg)
	e12:SetOperation(ref.hspop)
	c:RegisterEffect(e12)
end
function ref.matfilter1(c,ec,tp)
	return c:IsAttribute(ATTRIBUTE_FIRE) or c:IsRace(RACE_WARRIOR)
end
function ref.matfilter2(c,ec,tp)
	return c:IsRace(RACE_WARRIOR)
end

--Removal
function ref.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanRemoveCounter(tp,0x111f,4,REASON_COST) and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	c:RemoveCounter(tp,0x111f,4,REASON_EFFECT)
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function ref.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroup(Card.IsFaceup,1-tp,LOCATION_MZONE,0,nil):GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,0,LOCATION_MZONE)
	Duel.SetChainLimit(ref.chlimit)
end
function ref.chlimit(e,ep,tp)
	return tp==ep
end
function ref.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,1-tp,LOCATION_MZONE,0,nil)
	local ct=2
	if g:GetCount()==1 then ct=1 end
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g:Select(1-tp,ct,ct,nil)
		Duel.HintSelection(sg)
		if Duel.SendtoGrave(sg,REASON_RULE)==2 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CHANGE_DAMAGE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(0,1)
			e1:SetValue(0)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
function ref.hspfilter(c,tp,sc)
	return c:IsType(TYPE_MONSTER) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
end
function ref.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(ref.hspfilter,tp,LOCATION_MZONE,0,1,nil)
end
function ref.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.SelectMatchingCard(tp,ref.hspfilter,tp,LOCATION_MZONE,0,1,99,nil,e,tp)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
	return true
	end
	return false
end
function ref.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
		c:SetMaterial(g)
	Duel.Release(g,REASON_MATERIAL+REASON_EVOLUTE)
	g:DeleteGroup()
end
