EFFECT_HAND_TIMESPACE	= 1200000
REASON_TIMESPACE		= 0x12800000
SUMMON_TYPE_TIMESPACE 	= 0x12800000
HINTMSG_TIMESPACEMATERIAL	= 12800000
TIMESPACE_IMPORTED	= true
if not aux.TimespaceProcedure then
	aux.TimespaceProcedure = {}
	Timespace = aux.TimespaceProcedure
end
if not Timespace then
	Timespace = aux.TimespaceProcedure
end
--[[
add at the start of the script to add tinespace procedure
if not TIMESPACE_IMPORTED then Duel.LoadScript("proc_timespace.lua") end
condition if Timespace summoned
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_TYPE_TIMESPACE
]]
--Timespace Summon
function Timespace.AddProcedure(c,f,min,max,specialchk,opp,loc,send)
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
	if c.timespace_type==nil then
		local mt=c:GetMetatable()
		mt.timespace_type=1
		mt.timespace_parameters={c,f,min,max,control,location,operation}
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetDescription(1181)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Timespace.Condition(f,min,max,specialchk,opp,loc,send))
	e1:SetTarget(Timespace.Target(f,min,max,specialchk,opp,loc,send))
	e1:SetOperation(Timespace.Operation(f,min,max,specialchk,opp,loc,send))
    e1:SetValue(SUMMON_TYPE_TIMESPACE)
	c:RegisterEffect(e1)
	--scale
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	--e3:SetCode(EFFECT_CHANGE_RANK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	--e3:SetRange(LOCATION_MZONE)
	--e3:SetValue(Timespace.Level)
	--c:RegisterEffect(e3)
	--local e4=e3:Clone()
	e3:SetCode(EFFECT_REMOVE_TYPE)
	e3:SetValue(TYPE_SYNCHRO)
	c:RegisterEffect(e3)
--
        --local e9=Effect.CreateEffect(c)
	--e9:SetType(EFFECT_TYPE_SINGLE)
	--e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	--e9:SetCode(EFFECT_CHANGE_LEVEL)
	--e9:SetValue(0)
	--c:RegisterEffect(e9)
--
	--local e10=Effect.CreateEffect(c)
	--e10:SetType(EFFECT_TYPE_SINGLE)
	--e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	--e10:SetCode(EFFECT_ALLOW_NEGATIVE)
	--c:RegisterEffect(e10)
	--[[scale
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMOVE_TYPE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetValue(TYPE_SYNCHRO)
	c:RegisterEffect(e3)]]
end
function Card.IsTimespace(c)
	return c.IsTimeSpace
end
function Timespace.ConditionFilter(c,f,lc,tp)
	return (not f or f(c,lc,SUMMON_TYPE_SPECIAL,tp)) and not (c:IsHasEffect(50031787,tp) or (c:IsHasEffect(221594300) and c:IsLocation(LOCATION_MZONE)))
end
function Timespace.GetTimespaceCount(c)
    if c:GetAttack()>1 then return c:GetAttack() end
    return 1
end
function Timespace.CheckRecursive(c,tp,sg,mg,lc,minc,maxc,f,specialchk,og,emt,filt)
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
	local res=Timespace.CheckGoal(tp,sg,lc,minc,f,specialchk,filt)
		or (#sg<maxc and mg:IsExists(Timespace.CheckRecursive,1,sg,tp,sg,mg,lc,minc,maxc,f,specialchk,og,emt,{table.unpack(filt)}))
	sg:RemoveCard(c)
	return res
end
function Timespace.CheckRecursive2(c,tp,sg,sg2,secondg,mg,lc,minc,maxc,f,specialchk,og,emt,filt)
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
			local res=secondg:IsExists(Timespace.CheckRecursive,1,sg,tp,sg,mg,lc,minc,maxc,f,specialchk,og,emt,{table.unpack(filt)})
			sg:RemoveCard(c)
			return res
		else
			local res=Timespace.CheckGoal(tp,sg,lc,minc,f,specialchk,{table.unpack(filt)})
			sg:RemoveCard(c)
			return res
		end
	end
	local res=Timespace.CheckRecursive2((sg2-sg):GetFirst(),tp,sg,sg2,secondg,mg,lc,minc,maxc,f,specialchk,og,emt,filt)
	sg:RemoveCard(c)
	return res
end
function Timespace.CheckGoal(tp,sg,lc,minc,f,specialchk,filt)
	for _,filt in ipairs(filt) do
		if not sg:IsExists(filt[2],1,nil,filt[3],tp,sg,Group.CreateGroup(),lc,filt[1],1) then
			return false
		end
	end
	return #sg>=minc and sg:CheckWithSumEqual(Timespace.GetTimespaceCount,lc:GetAttack()-1000,#sg,#sg)
		and (not specialchk or specialchk(sg,lc,SUMMON_TYPE_SPECIAL,tp)) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0
end
function Timespace.Condition(f,minc,maxc,specialchk,opp,loc,send)
	return	function(e,c,must,g,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local loc2=0
				if opp then loc2=loc end
				if not g then
					g=Duel.GetMatchingGroup(Card.IsFaceup,tp,loc,loc2,nil)
g:Merge(Duel.GetMatchingGroup(Auxiliary.TimespaceSummonSubstitute,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE,0,nil,c:GetControler()))
				end
				local mg=g:Filter(Timespace.ConditionFilter,nil,f,c,tp)
				local mustg=Auxiliary.GetMustBeMaterialGroup(tp,g,tp,c,mg,REASON_TIMESPACE)
				if must then mustg:Merge(must) end
				if min and min < minc then return false end
				if max and max > maxc then return false end
				min = min or minc
				max = max or maxc
				if mustg:IsExists(aux.NOT(Timespace.ConditionFilter),1,nil,f,c,tp) or #mustg>max then return false end
				local emt,tg=aux.GetExtraMaterials(tp,mustg+mg,c,SUMMON_TYPE_TIMESPACE)
				tg=tg:Filter(Timespace.ConditionFilter,nil,f,c,tp)
				local res=(mg+tg):Includes(mustg) and #mustg<=max
				if res then
					if #mustg==max then
						local sg=Group.CreateGroup()
						res=mustg:IsExists(Timespace.CheckRecursive,1,sg,tp,sg,(mg+tg),c,min,max,f,specialchk,mg,emt)
					elseif #mustg<max then
						local sg=mustg
						res=(mg+tg):IsExists(Timespace.CheckRecursive,1,sg,tp,sg,(mg+tg),c,min,max,f,specialchk,mg,emt)
					end
				end
				aux.DeleteExtraMaterialGroups(emt)
				return res
			end
end
function Timespace.Target(f,minc,maxc,specialchk,opp,loc,send)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,must,g,min,max)
				local loc2=0
				if opp then loc2=loc end
				if not g then
					g=Duel.GetMatchingGroup(Card.IsFaceup,tp,loc,loc2,nil)
g:Merge(Duel.GetMatchingGroup(Auxiliary.TimespaceSummonSubstitute,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE,0,nil,c:GetControler()))
				end
				if min and min < minc then return false end
				if max and max > maxc then return false end
				min = min or minc
				max = max or maxc
				local mg=g:Filter(Timespace.ConditionFilter,nil,f,c,tp)
				local mustg=Auxiliary.GetMustBeMaterialGroup(tp,g,tp,c,mg,REASON_TIMESPACE)
				if must then mustg:Merge(must) end
				local emt,tg=aux.GetExtraMaterials(tp,mustg+mg,c,SUMMON_TYPE_TIMESPACE)
				tg=tg:Filter(Timespace.ConditionFilter,nil,f,c,tp)
				local sg=Group.CreateGroup()
				local finish=false
				local cancel=false
				sg:Merge(mustg)
				while #sg<max do
					local filters={}
					if #sg>0 then
						Timespace.CheckRecursive2(sg:GetFirst(),tp,Group.CreateGroup(),sg,mg+tg,mg+tg,c,min,max,f,specialchk,mg,emt,filters)
					end
					local cg=(mg+tg):Filter(Timespace.CheckRecursive,sg,tp,sg,(mg+tg),c,min,max,f,specialchk,mg,emt,{table.unpack(filters)})
					if #cg==0 then break end
					finish=#sg>=min and #sg<=max and Timespace.CheckGoal(tp,sg,c,min,f,specialchk,filters)
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
					Timespace.CheckRecursive2(sg:GetFirst(),tp,Group.CreateGroup(),sg,mg+tg,mg+tg,c,min,max,f,specialchk,mg,emt,filters)
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
function Timespace.Operation(f,minc,maxc,specialchk,opp,loc,send)
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
					Duel.SendtoGrave(g,REASON_MATERIAL+REASON_TIMESPACE+REASON_RETURN)
				elseif send==2 then
					Duel.Remove(g,POS_FACEUP,REASON_MATERIAL+REASON_TIMESPACE)
				elseif send==3 then
					Duel.Remove(g,POS_FACEDOWN,REASON_MATERIAL+REASON_TIMESPACE)
				elseif send==4 then
					Duel.SendtoHand(g,nil,REASON_MATERIAL+REASON_TIMESPACE)
				elseif send==5 then
					Duel.SendtoDeck(g,nil,2,REASON_MATERIAL+REASON_TIMESPACE)
				elseif send==6 then
					Duel.Destroy(g,REASON_MATERIAL+REASON_TIMESPACE)
				else
					Duel.SendtoGrave(g,REASON_MATERIAL+REASON_TIMESPACE)
				end
				g:DeleteGroup()
				aux.DeleteExtraMaterialGroups(emt)
		--e:GetHandler():SetTurnCounter(e:GetHandler():GetOriginalLevel())
			end
end
function Timespace.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_TIMESPACE)
end
function Timespace.Neutral(c,e)
	return c:GetAttack()==c:GetDefense()
end
function Timespace.negative(c,e)
	return c:GetAttack()<c:GetDefense()
end
function Timespace.Positive(c,e)
	return c:GetAttack()>c:GetDefense()
end
function Timespace.Level(e)
	local lv=e:GetHandler():GetOriginalLevel()
	return lv
end
function Auxiliary.TimespaceSummonSubstitute(c,cd,tp)
	return c:IsHasEffect(52401238,tp) and c:IsAbleToGraveAsCost()
end
function Auxiliary.AddConvergentTSSummonProcedure(c,f,min,max,specialchk,desc)
--AddConvergentEvolSummonProcedure(c,code,loc,excon)
	--[[special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
    e1:SetValue(SUMMON_TYPE_TIMESPACE)
	e1:SetCondition(Auxiliary.ConvergentTSSummonCondition(code,loc,excon))
	e1:SetTarget(Auxiliary.ConvergentTSSummonTarget(code,loc))
	e1:SetOperation(Auxiliary.ConvergentTSSummonOperation(code,loc))
	c:RegisterEffect(e1)]] 
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	if desc then
		e1:SetDescription(desc)
	else
		e1:SetDescription(1174)
	end
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	if max==nil then max=min end
	e1:SetCondition(Auxiliary.CTSCondition(f,min,max,specialchk))
	e1:SetTarget(Auxiliary.CTSTarget(f,min,max,specialchk))
	e1:SetOperation(Auxiliary.CTSOperation(f,min,max,specialchk))
	e1:SetValue(SUMMON_TYPE_TIMESPACE)
	c:RegisterEffect(e1)
end
function Auxiliary.CTSConditionFilter(c,f,lc,tp)
	return (not f or f(c,lc,SUMMON_TYPE_TIMESPACE,tp))
end
function Auxiliary.CTSGetCount(c)
	if c:IsLinkMonster() and c:GetLink()>1 then
		return 1+0x10000*c:GetLink()
	else return 1 end
end
function Auxiliary.CTSCheckRecursive(c,tp,sg,mg,lc,minc,maxc,f,specialchk,og,emt,filt)
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
	local res=Auxiliary.CTSCheckGoal(tp,sg,lc,minc,f,specialchk,filt)
		or (#sg<maxc and mg:IsExists(Auxiliary.CTSCheckRecursive,1,sg,tp,sg,mg,lc,minc,maxc,f,specialchk,og,emt,{table.unpack(filt)}))
	sg:RemoveCard(c)
	return res
end
function Auxiliary.CTSCheckRecursive2(c,tp,sg,sg2,secondg,mg,lc,minc,maxc,f,specialchk,og,emt,filt)
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
			local res=secondg:IsExists(Auxiliary.CTSCheckRecursive,1,sg,tp,sg,mg,lc,minc,maxc,f,specialchk,og,emt,{table.unpack(filt)})
			sg:RemoveCard(c)
			return res
		else
			local res=Auxiliary.CTSCheckGoal(tp,sg,lc,minc,f,specialchk,{table.unpack(filt)})
			sg:RemoveCard(c)
			return res
		end
	end
	local res=Auxiliary.CTSCheckRecursive2((sg2-sg):GetFirst(),tp,sg,sg2,secondg,mg,lc,minc,maxc,f,specialchk,og,emt,filt)
	sg:RemoveCard(c)
	return res
end
function Auxiliary.CTSCheckGoal(tp,sg,lc,minc,f,specialchk,filt)
	for _,filt in ipairs(filt) do
		if not sg:IsExists(filt[2],1,nil,filt[3],tp,sg,Group.CreateGroup(),lc,filt[1],1) then
			return false
		end
	end
	return 
--#sg>=minc and sg:CheckWithSumEqual(Auxiliary.CTSGetCount,4,#sg,#sg) and 
(not specialchk or specialchk(sg,lc,SUMMON_TYPE_TIMESPACE,tp)) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0
end
function Auxiliary.CTSCondition(f,minc,maxc,specialchk)
	return	function(e,c,must,g,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				if not g then
					g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
				end
				local mg=g:Filter(Auxiliary.CTSConditionFilter,nil,f,c,tp)
				local mustg=Auxiliary.GetMustBeMaterialGroup(tp,g,tp,c,mg,REASON_TIMESPACE)
				if must then mustg:Merge(must) end
				--if min and min < minc then return false end
				if max and max > maxc then return false end
				min = min
-- or minc
				max = max or maxc
				if mustg:IsExists(aux.NOT(Auxiliary.CTSConditionFilter),1,nil,f,c,tp) or #mustg>max then return false end
				local emt,tg=aux.GetExtraMaterials(tp,mustg+mg,c,SUMMON_TYPE_TIMESPACE)
				tg:Match(Auxiliary.CTSConditionFilter,nil,f,c,tp)
				local mg_tg=mg+tg
				local res=mg_tg:Includes(mustg) and #mustg<=max
				if res then
					if #mustg==max then
						local sg=Group.CreateGroup()
						res=mustg:IsExists(Auxiliary.CTSCheckRecursive,1,sg,tp,sg,mg_tg,c,min,max,f,specialchk,mg,emt)
					elseif #mustg<max then
						local sg=mustg
						res=mg_tg:IsExists(Auxiliary.CTSCheckRecursive,1,sg,tp,sg,mg_tg,c,min,max,f,specialchk,mg,emt)
					end
				end
				aux.DeleteExtraMaterialGroups(emt)
				return res
			end
end
function Auxiliary.CTSTarget(f,minc,maxc,specialchk)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,must,g,min,max)
				if not g then
					g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
				end
				if min and min < minc then return false end
				if max and max > maxc then return false end
				min = min or minc
				max = max or maxc
				local mg=g:Filter(Auxiliary.CTSConditionFilter,nil,f,c,tp)
				local mustg=Auxiliary.GetMustBeMaterialGroup(tp,g,tp,c,mg,REASON_TIMESPACE)
				if must then mustg:Merge(must) end
				local emt,tg=aux.GetExtraMaterials(tp,mustg+mg,c,SUMMON_TYPE_TIMESPACE)
				tg:Match(Auxiliary.CTSConditionFilter,nil,f,c,tp)
				local sg=Group.CreateGroup()
				local finish=false
				local cancel=false
				sg:Merge(mustg)
				local mg_tg=mg+tg
				while #sg<max do
					local filters={}
					if #sg>0 then
						Auxiliary.CTSCheckRecursive2(sg:GetFirst(),tp,Group.CreateGroup(),sg,mg_tg,mg_tg,c,min,max,f,specialchk,mg,emt,filters)
					end
					local cg=mg_tg:Filter(Auxiliary.CTSCheckRecursive,sg,tp,sg,mg_tg,c,min,max,f,specialchk,mg,emt,{table.unpack(filters)})
					if #cg==0 then break end
					finish=#sg>=min and #sg<=max and Auxiliary.CTSCheckGoal(tp,sg,c,min,f,specialchk,filters)
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
					Auxiliary.CTSCheckRecursive2(sg:GetFirst(),tp,Group.CreateGroup(),sg,mg_tg,mg_tg,c,min,max,f,specialchk,mg,emt,filters)
					sg:KeepAlive()
					e:SetLabelObject({sg,filters,emt})
					return true
				else 
					aux.DeleteExtraMaterialGroups(emt)
					return false
				end
			end
end
function Auxiliary.CTSOperation(f,minc,maxc,specialchk)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,must,g,min,max)
				local g,filt,emt=table.unpack(e:GetLabelObject())
				for _,ex in ipairs(filt) do
					if ex[3]:GetValue() then
						ex[3]:GetValue()(1,SUMMON_TYPE_TIMESPACE,ex[3],ex[1]&g,c,tp)
						if ex[3]:CheckCountLimit(tp) then
							ex[3]:UseCountLimit(tp,1)
						end
					end
				end
				c:SetMaterial(g)
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_TIMESPACE)
				g:DeleteGroup()
				aux.DeleteExtraMaterialGroups(emt)
			end
end
