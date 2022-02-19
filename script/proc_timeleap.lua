EFFECT_HAND_TIMELP	= 601100000
REASON_TIMELP		= 0x40000000000
SUMMON_TYPE_TIMELP	= 0x400000000
HINTMSG_TLPMATERIAL	= 400000000
TIMELEAP_IMPORTED	= true
if not aux.TIMELEAPProcedure then
	aux.TimeleapProcedure = {}
	Timeleap = aux.TimeleapProcedure
end
if not Timeleap then
	Timeleap = aux.TimeleapProcedure
end
--[[
add at the start of the script to add Timeleap procedure
if not TIMELEAP_IMPORTED then Duel.LoadScript("proc_timeleap.lua") end
condition if Timeleap summoned
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_TYPE_TIMELEAP
]]
--Reunion Summon
function Timeleap.AddProcedure(c,f,min,max,specialchk,opp,loc,send)
    -- opp==true >> you can use opponent monsters as materials (default false)
    -- loc default LOCATION_MZONE
	-- send materials:
	-- 1 >> grave
	-- 2 >> remove face-up
	-- 3 >> remove face-down
	-- 4 >> hand
	-- 5 >> deck
	-- 6 >> destroy
	if loc==nil then loc=LOCATION_MZONE end
	if c.timeleap_type==nil then
		local mt=c:GetMetatable()
		mt.timeleap_type=1
		mt.timeleap_parameters={c,f,min,max,control,location,operation}
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetDescription(1181)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Timeleap.Condition(f,min,max,specialchk,opp,loc,send))
	e1:SetTarget(Timeleap.Target(f,min,max,specialchk,opp,loc,send))
	e1:SetOperation(Timeleap.Operation(f,min,max,specialchk,opp,loc,send))
    e1:SetValue(SUMMON_TYPE_TIMELEAP)
	c:RegisterEffect(e1)
end
function Card.IsTimeleap(c)
	return c.IsTimeleap
end
function Timeleap.ConditionFilter(c,f,lc,tp)
	return not f or f(c,lc,SUMMON_TYPE_SPECIAL,tp)
end
function Timeleap.GetEvoluteCount(c)
    if c:GetLevel()>0 then return c:GetLevel()
    elseif c:GetRank()>0 then return c:GetRank()
    elseif c:GetLink()>0 then return c:GetLink() end
    return 0
end
function Timeleap.CheckRecursive(c,tp,sg,mg,lc,minc,maxc,f,specialchk,og,emt,filt)
	if #sg>maxc then return false end
	filt=filt or {}
	sg:AddCard(c)
	for _,filt in ipairs(filt) do
		if not filt[2](c,filt[3],tp,sg,mg,lc,filt[1],1) then
			sg:RemoveCard(c)
			return false
		end
	end
	if not og:IsContains(c) then
		res=aux.CheckValidExtra(c,tp,sg,mg,lc,emt,filt)
		if not res then
			sg:RemoveCard(c)
			return false
		end
	end
	local res=Timeleap.CheckGoal(tp,sg,lc,minc,f,specialchk,filt)
		or (#sg<maxc and mg:IsExists(Evolute.CheckRecursive,1,sg,tp,sg,mg,lc,minc,maxc,f,specialchk,og,emt,{table.unpack(filt)}))
	sg:RemoveCard(c)
	return res
end
function Timeleap.CheckRecursive2(c,tp,sg,sg2,secondg,mg,lc,minc,maxc,f,specialchk,og,emt,filt)
	if #sg>maxc then return false end
	sg:AddCard(c)
	for _,filt in ipairs(filt) do
		if not filt[2](c,filt[3],tp,sg,mg,lc,filt[1],1) then
			sg:RemoveCard(c)
			return false
		end
	end
	if not og:IsContains(c) then
		res=aux.CheckValidExtra(c,tp,sg,mg,lc,emt,filt)
		if not res then
			sg:RemoveCard(c)
			return false
		end
	end
	if #(sg2-sg)==0 then
		if secondg and #secondg>0 then
			local res=secondg:IsExists(Timeleap.CheckRecursive,1,sg,tp,sg,mg,lc,minc,maxc,f,specialchk,og,emt,{table.unpack(filt)})
			sg:RemoveCard(c)
			return res
		else
			local res=TimeLeap.CheckGoal(tp,sg,lc,minc,f,specialchk,{table.unpack(filt)})
			sg:RemoveCard(c)
			return res
		end
	end
	local res=Timeleap.CheckRecursive2((sg2-sg):GetFirst(),tp,sg,sg2,secondg,mg,lc,minc,maxc,f,specialchk,og,emt,filt)
	sg:RemoveCard(c)
	return res
end
function Timeleap.CheckGoal(tp,sg,lc,minc,f,specialchk,filt)
	for _,filt in ipairs(filt) do
		if not sg:IsExists(filt[2],1,nil,filt[3],tp,sg,Group.CreateGroup(),lc,filt[1],1) then
			return false
		end
	end
	return #sg>=minc and sg:CheckWithSumEqual(Timeleap.GetEvoluteCount,lc:GetLevel()-1,#sg,#sg)
		and (not specialchk or specialchk(sg,lc,SUMMON_TYPE_SPECIAL,tp)) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0
end
function Timeleap.Condition(f,minc,maxc,specialchk,opp,loc,send)
	return	function(e,c,must,g,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local loc2=0
				if opp then loc2=loc end
				if not g then
					g=Duel.GetMatchingGroup(Card.IsFaceup,tp,loc,loc2,nil)
				end
				local mg=g:Filter(Timeleap.ConditionFilter,nil,f,c,tp)
				local mustg=Auxiliary.GetMustBeMaterialGroup(tp,g,tp,c,mg,REASON_TIMELEAP)
				if must then mustg:Merge(must) end
				if min and min < minc then return false end
				if max and max > maxc then return false end
				min = min or minc
				max = max or maxc
				if mustg:IsExists(aux.NOT(Timeleap.ConditionFilter),1,nil,f,c,tp) or #mustg>max then return false end
				local emt,tg=aux.GetExtraMaterials(tp,mustg+mg,c,SUMMON_TYPE_TIMELEAP)
				tg=tg:Filter(Timeleap.ConditionFilter,nil,f,c,tp)
				local res=(mg+tg):Includes(mustg) and #mustg<=max
				if res then
					if #mustg==max then
						local sg=Group.CreateGroup()
						res=mustg:IsExists(Timeleap.CheckRecursive,1,sg,tp,sg,(mg+tg),c,min,max,f,specialchk,mg,emt)
					elseif #mustg<max then
						local sg=mustg
						res=(mg+tg):IsExists(Timeleap.CheckRecursive,1,sg,tp,sg,(mg+tg),c,min,max,f,specialchk,mg,emt)
					end
				end
				aux.DeleteExtraMaterialGroups(emt)
				return res
			end
end
function Timeleap.Target(f,minc,maxc,specialchk,opp,loc,send)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,must,g,min,max)
				local loc2=0
				if opp then loc2=loc end
				if not g then
					g=Duel.GetMatchingGroup(Card.IsFaceup,tp,loc,loc2,nil)
				end
				if min and min < minc then return false end
				if max and max > maxc then return false end
				min = min or minc
				max = max or maxc
				local mg=g:Filter(Timeleap.ConditionFilter,nil,f,c,tp)
				local mustg=Auxiliary.GetMustBeMaterialGroup(tp,g,tp,c,mg,REASON_TIMELEAP)
				if must then mustg:Merge(must) end
				local emt,tg=aux.GetExtraMaterials(tp,mustg+mg,c,SUMMON_TYPE_TIMELEAP)
				tg=tg:Filter(Timeleap.ConditionFilter,nil,f,c,tp)
				local sg=Group.CreateGroup()
				local finish=false
				local cancel=false
				sg:Merge(mustg)
				while #sg<max do
					local filters={}
					if #sg>0 then
						Timeleap.CheckRecursive2(sg:GetFirst(),tp,Group.CreateGroup(),sg,mg+tg,mg+tg,c,min,max,f,specialchk,mg,emt,filters)
					end
					local cg=(mg+tg):Filter(Timeleap.CheckRecursive,sg,tp,sg,(mg+tg),c,min,max,f,specialchk,mg,emt,{table.unpack(filters)})
					if #cg==0 then break end
					finish=#sg>=min and #sg<=max and Timeleap.CheckGoal(tp,sg,c,min,f,specialchk,filters)
					cancel=not og and Duel.IsSummonCancelable() and #sg==0
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
					local tc=Group.SelectUnselect(cg,sg,tp,finish,cancel,1,1)
					if not tc then break end
					if #mustg==0 or not mustg:IsContains(tc) then
						if not sg:IsContains(tc) then
							sg:AddCard(tc)
						else
							sg:RemoveCard(tc)
						end
					end
				end
				if #sg>0 then
					local filters={}
					Timeleap.CheckRecursive2(sg:GetFirst(),tp,Group.CreateGroup(),sg,mg+tg,mg+tg,c,min,max,f,specialchk,mg,emt,filters)
					sg:KeepAlive()
					local reteff=Effect.GlobalEffect()
					reteff:SetTarget(function()return sg,filters,emt end)
					e:SetLabelObject(reteff)
					return true
				else 
					aux.DeleteExtraMaterialGroups(emt)
					return false
				end
			end
end
function Timeleap.Operation(f,minc,maxc,specialchk,opp,loc,send)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,must,g,min,max)
				local g,filt,emt=e:GetLabelObject():GetTarget()()
				e:GetLabelObject():Reset()
				for _,ex in ipairs(filt) do
					if ex[3]:GetValue() then
						ex[3]:GetValue()(1,SUMMON_TYPE_SPECIAL,ex[3],ex[1]&g,c,tp)
					end
				end
				c:SetMaterial(g)
				if send==1 then
					Duel.SendtoGrave(g,REASON_MATERIAL+REASON_TIMELEAP+REASON_RETURN)
				elseif send==2 then
					Duel.Remove(g,POS_FACEUP,REASON_MATERIAL+REASON_TIMELEAP)
				elseif send==3 then
					Duel.Remove(g,POS_FACEDOWN,REASON_MATERIAL+REASON_TIMELEAP)
				elseif send==4 then
					Duel.SendtoHand(g,nil,REASON_MATERIAL+REASON_TIMELEAP)
				elseif send==5 then
					Duel.SendtoDeck(g,nil,2,REASON_MATERIAL+REASON_TIMELEAP)
				elseif send==6 then
					Duel.Destroy(g,REASON_MATERIAL+REASON_TIMELEAP)
				else
					Duel.SendtoGrave(g,REASON_MATERIAL+REASON_TIMELEAP)
				end
				g:DeleteGroup()
				aux.DeleteExtraMaterialGroups(emt)
			end
end
