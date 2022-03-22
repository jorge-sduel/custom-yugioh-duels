SUMMON_TYPE_EQUILIBRIUM = 0x4000000000000000000000
CATEGORY_ATTACH_EQUILIBRIUM  = 0x4000000000
EQUILIBRIUM_IMPORTED=true
if not aux.EquilibriumProcedure then
	aux.EquilibriumProcedure = {}
	Equilibrium = aux.EquilibriumProcedure
end
if not Equilibrium then
	Equilibrium = aux.EquilibriumProcedure
end
--add procedure to Pendulum monster, also allows registeration of activation effect
Equilibrium.AddProcedure = aux.FunctionWithNamedArgs(
function(c,reg,desc)
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_REMOVE_TYPE)
	ea:SetValue(TYPE_SPELL)
	ea:SetRange(LOCATION_PZONE)
	c:RegisterEffect(ea)
	local eb=Effect.CreateEffect(c)
	eb:SetType(EFFECT_ADD_TYPE)
	eb:SetValue(TYPE_TRAP)
	eb:SetRange(LOCATION_PZONE)
	c:RegisterEffect(eb)
	local ec=Effect.CreateEffect(c)
	ec:SetType(EFFECT_REMOVE_TYPE)
	ec:SetValue(TYPE_PENDULUM)
	ec:SetRange(LOCATION_PZONE)
	c:RegisterEffect(ec)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	if desc then
		e1:SetDescription(desc)
	else
		e1:SetDescription(1074)
	end
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(Equilibrium.Condition())
	e1:SetOperation(Equilibrium.Operation())
	e1:SetValue(SUMMON_TYPE_EQUILIBRIUM)
	c:RegisterEffect(e1)
	--register by default
	if reg==nil or reg then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_REMOVE_TYPE)
		e2:SetValue(TYPE_SPELL)
		e2:SetRange(LOCATION_PZONE)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_ADD_TYPE)
		e3:SetValue(TYPE_TRAP)
		e3:SetRange(LOCATION_PZONE)
		c:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_REMOVE_TYPE)
		e4:SetValue(TYPE_PENDULUM)
		e4:SetRange(LOCATION_PZONE)
		c:RegisterEffect(e4)
	end
end,"handler","register","desc")
function Equilibrium.Filter(c,e,tp,lscale,rscale,lvchk)
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
		and (lvchk or (lv>lscale and lv<rscale) or c:IsHasEffect(511004423)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false)
		and not c:IsForbidden()
end
function Equilibrium.Condition()
	return	function(e,c,ischain,re,rp)
				if c==nil then return true end
				local tp=c:GetControler()
				if not inchain and Duel.GetFlagEffect(tp,10000000)>0 then return false end
				local lscale=c:GetLeftScale()
				local rscale=c:GetRightScale()
				local loc=0
				if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
				if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)>0 then loc=loc+LOCATION_EXTRA end
				if loc==0 then return false end
				local g=nil
				if og then
					g=og:Filter(Card.IsLocation,nil,loc)
				else
					g=Duel.GetFieldGroup(tp,loc,0)
				end
				return g:IsExists(Pendulum.Filter,1,nil,e,tp,lscale,rscale,c:IsHasEffect(511007000) and rpz:IsHasEffect(511007000))
			end
end
function Equilibrium.Operation()
	return	function(e,tp,eg,ep,ev,re,r,rp,c,sg,inchain)
				local lscale=c:GetLeftScale()
				local rscale=c:GetRightScale()
				local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
				local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
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
					tg=og:Filter(Card.IsLocation,nil,loc):Filter(Pendulum.Filter,nil,e,tp,lscale,rscale,c:IsHasEffect(511007000) and rpz:IsHasEffect(511007000))
				else
					tg=Duel.GetMatchingGroup(Pendulum.Filter,tp,loc,0,nil,e,tp,lscale,rscale,c:IsHasEffect(511007000) and rpz:IsHasEffect(511007000))
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
					local tc=Group.SelectUnselect(g,sg,tp,#sg>0,Duel.IsSummonCancelable())
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
						if c:IsHasEffect(511007000)~=nil or c:IsHasEffect(511007000)~=nil then
							if not Pendulum.Filter(tc,e,tp,lscale,rscale) then
								local pg=sg:Filter(aux.TRUE,tc)
								local ct0,ct3,ct4=#pg,pg:FilterCount(Card.IsLocation,nil,LOCATION_HAND),pg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
								sg:Sub(pg)
								ft1=ft1+ct3
								ft2=ft2+ct4
								ft=ft+ct0
							else
								local pg=sg:Filter(aux.NOT(Pendulum.Filter),nil,e,tp,lscale,rscale)
								sg:Sub(pg)
								if #pg>0 then
									if pg:GetFirst():IsLocation(LOCATION_HAND) then
										ft1=ft1+1
									else
										ft2=ft2+1
									end
									ft=ft+1
								end
							end
						end
						if tc:IsLocation(LOCATION_HAND) then
							ft1=ft1-1
						else
							ft2=ft2-1
						end
						ft=ft-1
					end
				end
				if #sg>0 then
					if not inchain then
						Duel.RegisterFlagEffect(tp,10000000,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,1)
					end
					Duel.HintSelection(Group.FromCards(c))
				end
			end
end
function Equilibrium.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_PZONE,0)
	Duel.SendtoExtraP(g,tp,REASON_EFFECT)
Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	Duel.Overlay(c,g)
end
function Equilibrium.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and Equilibrium.desfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(Equilibrium.desfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Equilibrium.desfilter,tp,LOCATION_PZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function Equilibrium.desop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
	Duel.SendtoExtraP(tc,tp,REASON_EFFECT)
Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	Duel.Overlay(c,tc)
	end
end
function Equilibrium.desfilter(c)
	return c:IsType(TYPE_PENDULUM)
end
