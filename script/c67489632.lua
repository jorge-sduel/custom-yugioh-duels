--Rift Storm
function c67489632.initial_effect(c)
	
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67489632,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c67489632.target)
	e1:SetOperation(c67489632.operation)
	c:RegisterEffect(e1)
	
	--Track whether a Spell/Trap was destroyed
	if not c67489632.global_check then
		c67489632.global_check=true
		local ge=Effect.CreateEffect(c)
		ge:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge:SetCode(EVENT_DESTROYED)
		ge:SetCondition(c67489632.checkcon)
		ge:SetOperation(c67489632.checkop)
		Duel.RegisterEffect(ge,0)
	end
end

--Spell/Trap filter
function c67489632.stfilter(c)
	return c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)
end

--Global check filter
function c67489632.checkfilter(c)
	return c67489632.stfilter(c) and (bit.band(c:GetReason(),0x41)==0x41) 
end

--Global check condition
function c67489632.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetFlagEffect(tp,67489632)==0) and
			(Duel.GetFlagEffect(1-tp,67489632)==0) and
			eg:IsExists(c67489632.checkfilter,1,nil)
end

--Global check operation
function c67489632.checkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,67489632,0,0,0)
end

--Destroy 1 card filter
function c67489632.singlefilter(c)
	return c67489632.stfilter(c) and c:IsFaceup()
end

--Target
function c67489632.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return true end
	
	local c = e:GetHandler()
	local md = ((Duel.GetFlagEffect(tp,67489632)~=0) or (Duel.GetFlagEffect(1-tp,67489632)~=0)) and
				Duel.GetFlagEffect(tp,67489633)==0 and
				Duel.IsExistingMatchingCard(c67489632.stfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
	local sd = Duel.IsExistingMatchingCard(c67489632.singlefilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)

	if chk==0 then return md or sd end
	
	local opt=0
	
	if sd and md then
		opt=Duel.SelectOption(tp,aux.Stringid(67489632,1),aux.Stringid(67489632,2))
	elseif sd then
		opt=Duel.SelectOption(tp,aux.Stringid(67489632,1))
	else
		opt=Duel.SelectOption(tp,aux.Stringid(67489632,2))+1
	end
	
	e:SetLabel(opt)
	
	if opt == 0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectTarget(tp,c67489632.singlefilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	else
		Duel.RegisterFlagEffect(tp,67489633,0,0,0)
		local sg=Duel.GetMatchingGroup(c67489632.stfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	end
end

--Operation
function c67489632.operation(e,tp,eg,ep,ev,re,r,rp)

	local opt=e:GetLabel()
	
	if opt == 0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	else
		local sg=Duel.GetMatchingGroup(c67489632.stfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
		Duel.Destroy(sg,REASON_EFFECT)
	end
end