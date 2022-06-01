TRAMPULA_IMPORTED=true
if not aux.TrampulaProcedure then
	aux.TrampulaProcedure = {}
	Trampula = aux.TrampulaProcedure
end
if not Trampula then
	Trampula = aux.TrampulaProcedure
end
--add procedure to Pendulum monster, also allows registeration of activation effect
Trampula.AddProcedure = aux.FunctionWithNamedArgs(
function(c,reg,desc)
		local ea=Effect.CreateEffect(c)
 		ea:SetDescription(69,1)
 		ea:SetType(EFFECT_TYPE_IGNITION)
 		ea:SetRange(LOCATION_HAND)
 		ea:SetOperation(Trampula.SetOp)
 		c:RegisterEffect(ea)
		local e1=Effect.CreateEffect(c)
 		e1:SetDescription(69,3)
 		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
 		e1:SetRange(LOCATION_PZONE)
 		e1:SetCondition(Trampula.Condition)
 		e1:SetOperation(Trampula.Operation)
	        local e2=Effect.CreateEffect(c)
	        e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	        e2:SetRange(LOCATION_MZONE)
	        e2:SetTargetRange(LOCATION_PZONE,0)
	        e2:SetTarget(Trampula.Efpendulum)
	        e2:SetLabelObject(e1)
	        c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	if desc then
		e3:SetDescription(desc)
	else
		e3:SetDescription(1074)
	end
	e3:SetCode(EFFECT_SPSUMMON_PROC_G)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(Trampula.Condition())
	e3:SetOperation(Trampula.Operation())
	e3:SetValue(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e3)
	--register by default
	if reg==nil or reg then
		local e4=Effect.CreateEffect(c)
 		e4:SetDescription(69,3)
 		e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
 		e4:SetRange(LOCATION_PZONE)
 		e4:SetCondition(Trampula.Condition)
 		e4:SetOperation(Trampula.Operation)
	        c:RegisterEffect(e4)
	end
end,"handler","register","desc")
function Trampula.Filter(c,e,tp,lscale,rscale,lvchk)
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
		and (lvchk or (lv>lscale and lv<rscale) or c:IsHasEffect(511004423)) and (c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false) or c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
		and not c:IsForbidden()
end
function Trampula.Condition(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if rpz==nil or c==rpz or Duel.GetFlagEffect(tp,29432356)>0 then return false end
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
	if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return false end
	local g=nil
	if og then
		g=og:Filter(Card.IsLocation,nil,loc)
	else
		g=Duel.GetFieldGroup(tp,loc,0)
	end
	return g:IsExists(Trampula.Filter,1,nil,e,tp,lscale,rscale)
end
function Trampula.Operation(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCountFromEx(tp)
	local ft=Duel.GetUsableMZoneCount(tp)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then
		if ft1>0 then ft1=1 end
		if ft2>0 then ft2=1 end
		ft=1
	end
	local loc=0
	if ft1>0 then loc=loc+LOCATION_HAND end
	if ft2>0 then loc=loc+LOCATION_EXTRA end
	local tg=nil
	if og then
		tg=og:Filter(Card.IsLocation,nil,loc):Filter(Trampula.Filter,nil,e,tp,lscale,rscale)
	else
		tg=Duel.GetMatchingGroup(Trampula.Filter,tp,loc,0,nil,e,tp,lscale,rscale)
	end
	ft1=math.min(ft1,tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND))
	ft2=math.min(ft2,tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA))
	ft2=math.min(ft2,aux.CheckSummonGate(tp) or ft2)
	while true do
		local ct1=tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
		local ct2=tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
		local ct=ft
		if ct1>ft1 then ct=math.min(ct,ft1) end
		if ct2>ft2 then ct=math.min(ct,ft2) end
		local loc=0
		if ft1>0 then loc=loc+LOCATION_HAND end
		if ft2>0 then loc=loc+LOCATION_EXTRA end
		local g=tg:Filter(Card.IsLocation,sg,loc)
		if #g==0 or ft==0 then break end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Group.SelectUnselect(g,sg,tp,true,true)
		if not tc then break end
		if sg:IsContains(tc) then
				sg:RemoveCard(tc)
				if tc:IsLocation(LOCATION_HAND) then
				ft1=ft1+1
			else
				ft2=ft2+1
			end
			ft=ft+1
		else
			sg:AddCard(tc)
			if tc:IsLocation(LOCATION_HAND) then
				ft1=ft1-1
			else
				ft2=ft2-1
			end
			ft=ft-1
		end
	end
	if #sg>0 then
		Duel.Hint(HINT_CARD,0,id)
		Duel.RegisterFlagEffect(tp,29432356,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,1)
		Duel.HintSelection(Group.FromCards(c))
		Duel.HintSelection(Group.FromCards(rpz))
	Duel.SpecialSummonStep(tc,SUMMON_TYPE_PENDULUM,tp,tp,true,true,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_ADD_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_MONSTER)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetCode(EFFECT_REMOVE_TYPE)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e2:SetValue(TYPE_TRAP)
			tc:RegisterEffect(e2)
	end
end
function Trampula.SetOp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEDOWN,true)

end
function Trampula.Efpendulum(e,c)
	return c:IsType(TYPE_PENDULUM)
end
