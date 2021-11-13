--Dark Antelion Fast Dragon
function c232.initial_effect(c)
--pendulum summon
	aux.EnablePendulumAttribute(c)
	Xyz.AddProcedure(c,nil,7,2)
	--xyz summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c232.xyzcon)
	e0:SetOperation(c232.xyzop)
	c:RegisterEffect(e0)
	local e1=e0:Clone()
	e1:SetRange(LOCATION_PZONE)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(43436049,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c232.cost)
	e2:SetTarget(c232.target)
	e2:SetOperation(c232.operation)
	c:RegisterEffect(e2)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(83303851,1))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetCountLimit(1)
	e4:SetCondition(c232.condition)
	e4:SetTarget(c232.destg)
	e4:SetOperation(c232.desop)
	c:RegisterEffect(e4)
	--to pendulum
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(128,2))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(c232.pencon)
	e5:SetTarget(c232.pentg)
	e5:SetOperation(c232.penop)
	c:RegisterEffect(e5)
end
c232.pendulum_level=6
function c232.ovfilter(c)
	return c:IsFaceup() and c:IsLevel(7)  or (c:IsRank(7) and c:IsHasEffect(EFFECT_XYZ_LEVEL))
end	
function c232.xyzcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c232.ovfilter,tp,LOCATION_MZONE,0,2,nil)
end
function c232.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	if chk==0 then return Duel.IsExistingMatchingCard(c232.ovfilter,tp,LOCATION_MZONE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=Duel.SelectMatchingCard(tp,c232.ovfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g2=Duel.SelectMatchingCard(tp,c232.ovfilter,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	og=Group.CreateGroup()
	og:Merge(g1)
	og:Merge(g2)
	if g1:GetCount()>0 then
		local mg1=g1:GetFirst():GetOverlayGroup()
		if mg1:GetCount()~=0 then
			og:Merge(mg1)
			Duel.Overlay(g2:GetFirst(),mg1)
		end
		Duel.Overlay(g2:GetFirst(),g1)
		local mg2=g2:GetFirst():GetOverlayGroup()
		if mg2:GetCount()~=0 then
			og:Merge(mg2)
			Duel.Overlay(c,mg2)
		end
		c:SetMaterial(og)
		Duel.Overlay(c,g2:GetFirst())	
	end
end
function c232.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at:GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function c232.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c232.filter(c)
	return c:IsLocation(LOCATION_SZONE) or c:IsLocation(LOCATION_PZONE)
end
function c232.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=-ft+1
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c232.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c232.filter,tp,LOCATION_ONFIELD,0,1,nil)
		and ct<=1 and (ct<=0 or Duel.IsExistingTarget(c232.filter,tp,LOCATION_MZONE,0,ct,nil))
		and not c:IsStatus(STATUS_CHAINING) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=nil
	if ct<=0 then
		g=Duel.SelectTarget(tp,c232.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	elseif ct==1 then
		g=Duel.SelectTarget(tp,c232.filter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g2=Duel.SelectTarget(tp,c232.filter,tp,LOCATION_ONFIELD,0,1,1,g:GetFirst())
		g:Merge(g2)
	else
		g=Duel.SelectTarget(tp,c232.filter,tp,LOCATION_MZONE,0,1,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c232.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) then return end
Duel.SpecialSummon(c,SUMMON_TYPE_SPECIAL,tp,tp,false,false,POS_FACEUP)
	end
end
function c232.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.disfilter1,tp,0,LOCATION_MZONE,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_MZONE,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function c232.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e3:SetValue(0)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
end
function c232.tglimit(e,c)
	return c~=e:GetHandler()
end
function c232.count(e,c)
	return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)-Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
end
function c232.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c232.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c232.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end