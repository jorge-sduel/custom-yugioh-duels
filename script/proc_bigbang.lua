EFFECT_HAND_BIGBANG	= 60111
REASON_BIGBANG		= 0x6400
SUMMON_TYPE_BIGBANG 	= 0x6400
HINTMSG_BIGBANGMATERIAL	= 6400
EFFECT_HAND_SPACET	= 601111
REASON_SPACET		= 0x2000000000000000
SUMMON_TYPE_SPACET 	= 0x20000000000000000
HINTMSG_SPACETMATERIAL	= 200000000000000000
BIGBANG_IMPORTED	= true
if not aux.BigbangProcedure then
	aux.BigbangProcedure = {}
	Bigbang = aux.BigbangProcedure
end
if not Bigbang then
	Bigbang = aux.BigbangProcedure
end
--[[
add at the start of the script to add bigbang procedure
if not BIGBANG_IMPORTED then Duel.LoadScript("proc_bigbang.lua") end
condition if Bigbang summoned
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_TYPE_BIGBANG
]]
--Bigbang Summon
function Bigbang.AddProcedure(c,f,min,max,specialchk,opp,loc,send)
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
	if c.bigbang_type==nil then
		local mt=c:GetMetatable()
		mt.bigbang_type=1
		mt.bigbang_parameters={c,f,min,max,control,location,operation}
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetDescription(1181)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Bigbang.Condition(f,min,max,specialchk,opp,loc,send))
	e1:SetTarget(Bigbang.Target(f,min,max,specialchk,opp,loc,send))
	e1:SetOperation(Bigbang.Operation(f,min,max,specialchk,opp,loc,send))
    e1:SetValue(SUMMON_TYPE_BIGBANG)
	c:RegisterEffect(e1)
	--scale
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	--e3:SetCode(EFFECT_CHANGE_RANK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	--e3:SetRange(LOCATION_MZONE)
	--e3:SetValue(Bigbang.Level)
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
end
function Card.IsBigbang(c)
	return c.IsBigbang
end
function Bigbang.ConditionFilter(c,f,lc,tp)
	return not f or f(c,lc,SUMMON_TYPE_SPECIAL,tp)
end
function Bigbang.GetBigbangCount(c)
    if c:GetAttack()>1 then return c:GetAttack() end
    return 1
end
function Bigbang.CheckRecursive(c,tp,sg,mg,lc,minc,maxc,f,specialchk,og,emt,filt)
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
	local res=Bigbang.CheckGoal(tp,sg,lc,minc,f,specialchk,filt)
		or (#sg<maxc and mg:IsExists(Bigbang.CheckRecursive,1,sg,tp,sg,mg,lc,minc,maxc,f,specialchk,og,emt,{table.unpack(filt)}))
	sg:RemoveCard(c)
	return res
end
function Bigbang.CheckRecursive2(c,tp,sg,sg2,secondg,mg,lc,minc,maxc,f,specialchk,og,emt,filt)
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
			local res=secondg:IsExists(Bigbang.CheckRecursive,1,sg,tp,sg,mg,lc,minc,maxc,f,specialchk,og,emt,{table.unpack(filt)})
			sg:RemoveCard(c)
			return res
		else
			local res=Bigbang.CheckGoal(tp,sg,lc,minc,f,specialchk,{table.unpack(filt)})
			sg:RemoveCard(c)
			return res
		end
	end
	local res=Bigbang.CheckRecursive2((sg2-sg):GetFirst(),tp,sg,sg2,secondg,mg,lc,minc,maxc,f,specialchk,og,emt,filt)
	sg:RemoveCard(c)
	return res
end
function Bigbang.CheckGoal(tp,sg,lc,minc,f,specialchk,filt)
	for _,filt in ipairs(filt) do
		if not sg:IsExists(filt[2],1,nil,filt[3],tp,sg,Group.CreateGroup(),lc,filt[1],1) then
			return false
		end
	end
	return #sg>=minc and sg:CheckWithSumEqual(Bigbang.GetBigbangCount,lc:GetAttack(),#sg,#sg)
		and (not specialchk or specialchk(sg,lc,SUMMON_TYPE_SPECIAL,tp)) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0
end
function Bigbang.Condition(f,minc,maxc,specialchk,opp,loc,send)
	return	function(e,c,must,g,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local loc2=0
				if opp then loc2=loc end
				if not g then
					g=Duel.GetMatchingGroup(Card.IsFaceup,tp,loc,loc2,nil)
g:Merge(Duel.GetMatchingGroup(Auxiliary.BigbangSummonSubstitute,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE,0,nil,c:GetControler()))
				end
				local mg=g:Filter(Bigbang.ConditionFilter,nil,f,c,tp)
				local mustg=Auxiliary.GetMustBeMaterialGroup(tp,g,tp,c,mg,REASON_BIGBANG)
				if must then mustg:Merge(must) end
				if min and min < minc then return false end
				if max and max > maxc then return false end
				min = min or minc
				max = max or maxc
				if mustg:IsExists(aux.NOT(Bigbang.ConditionFilter),1,nil,f,c,tp) or #mustg>max then return false end
				local emt,tg=aux.GetExtraMaterials(tp,mustg+mg,c,SUMMON_TYPE_BIGBANG)
				tg=tg:Filter(Bigbang.ConditionFilter,nil,f,c,tp)
				local res=(mg+tg):Includes(mustg) and #mustg<=max
				if res then
					if #mustg==max then
						local sg=Group.CreateGroup()
						res=mustg:IsExists(Bigbang.CheckRecursive,1,sg,tp,sg,(mg+tg),c,min,max,f,specialchk,mg,emt)
					elseif #mustg<max then
						local sg=mustg
						res=(mg+tg):IsExists(Bigbang.CheckRecursive,1,sg,tp,sg,(mg+tg),c,min,max,f,specialchk,mg,emt)
					end
				end
				aux.DeleteExtraMaterialGroups(emt)
				return res
			end
end
function Bigbang.Target(f,minc,maxc,specialchk,opp,loc,send)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,must,g,min,max)
				local loc2=0
				if opp then loc2=loc end
				if not g then
					g=Duel.GetMatchingGroup(Card.IsFaceup,tp,loc,loc2,nil)
g:Merge(Duel.GetMatchingGroup(Auxiliary.BigbangSummonSubstitute,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE,0,nil,c:GetControler()))
				end
				if min and min < minc then return false end
				if max and max > maxc then return false end
				min = min or minc
				max = max or maxc
				local mg=g:Filter(Bigbang.ConditionFilter,nil,f,c,tp)
				local mustg=Auxiliary.GetMustBeMaterialGroup(tp,g,tp,c,mg,REASON_BIGBANG)
				if must then mustg:Merge(must) end
				local emt,tg=aux.GetExtraMaterials(tp,mustg+mg,c,SUMMON_TYPE_BIGBANG)
				tg=tg:Filter(Bigbang.ConditionFilter,nil,f,c,tp)
				local sg=Group.CreateGroup()
				local finish=false
				local cancel=false
				sg:Merge(mustg)
				while #sg<max do
					local filters={}
					if #sg>0 then
						Bigbang.CheckRecursive2(sg:GetFirst(),tp,Group.CreateGroup(),sg,mg+tg,mg+tg,c,min,max,f,specialchk,mg,emt,filters)
					end
					local cg=(mg+tg):Filter(Bigbang.CheckRecursive,sg,tp,sg,(mg+tg),c,min,max,f,specialchk,mg,emt,{table.unpack(filters)})
					if #cg==0 then break end
					finish=#sg>=min and #sg<=max and Bigbang.CheckGoal(tp,sg,c,min,f,specialchk,filters)
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
					Bigbang.CheckRecursive2(sg:GetFirst(),tp,Group.CreateGroup(),sg,mg+tg,mg+tg,c,min,max,f,specialchk,mg,emt,filters)
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
function Bigbang.Operation(f,minc,maxc,specialchk,opp,loc,send)
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
					Duel.SendtoGrave(g,REASON_MATERIAL+REASON_BIGBANG+REASON_RETURN)
				elseif send==2 then
					Duel.Remove(g,POS_FACEUP,REASON_MATERIAL+REASON_BIGBANG)
				elseif send==3 then
					Duel.Remove(g,POS_FACEDOWN,REASON_MATERIAL+REASON_BIGBANG)
				elseif send==4 then
					Duel.SendtoHand(g,nil,REASON_MATERIAL+REASON_BIGBANG)
				elseif send==5 then
					Duel.SendtoDeck(g,nil,2,REASON_MATERIAL+REASON_BIGBANG)
				elseif send==6 then
					Duel.Destroy(g,REASON_MATERIAL+REASON_BIGBANG)
				else
					Duel.SendtoGrave(g,REASON_MATERIAL+REASON_BIGBANG)
				end
				g:DeleteGroup()
				aux.DeleteExtraMaterialGroups(emt)
		--e:GetHandler():SetTurnCounter(e:GetHandler():GetOriginalLevel())
			end
end
function Bigbang.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_BIGBANG)
end
function Bigbang.Neutral(c,e)
	return c:GetAttack()==c:GetDefense()
end
function Bigbang.negative(c,e)
	return c:GetAttack()<c:GetDefense()
end
function Bigbang.Positive(c,e)
	return c:GetAttack()>c:GetDefense()
end
function Bigbang.Level(e)
	local lv=e:GetHandler():GetOriginalLevel()
	return lv
end
function Auxiliary.BigbangSummonSubstitute(c,cd,tp)
	return c:IsHasEffect(52401238,tp) and c:IsAbleToGraveAsCost()
end
--Space-Time summon
function Auxiliary.AddSpacetSummonProcedure(c,code,loc,excon)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(SUMMON_TYPE_BIGBANG)
	e1:SetCondition(Auxiliary.SpacetSummonCondition(code,loc,excon))
	e1:SetTarget(Auxiliary.SpacetSummonTarget(code,loc))
	e1:SetOperation(Auxiliary.SpacetSummonOperation(code,loc))
	c:RegisterEffect(e1)
end
function Auxiliary.SpacetSummonFilter(e,c,cd,tp)
	return c:IsAttackAbove(Duel.GetLP(e:GetHandlerPlayer())) and not cd or cd(c,lc,SUMMON_TYPE_SPECIAL,tp)
--[((cd and c:IsCode(cd)) or (not cd or c.IsBigbang)) and c:IsAbleToRemoveAsCost()]
end
function Auxiliary.SpacetSummonSubstitute(c,cd,tp)
	return c:IsHasEffect(52401238,tp) and c:IsAbleToGraveAsCost()
end
function Auxiliary.SpacetSummonCondition(cd,loc,excon)
	return 	function(e,c)
				if excon and not excon(e,c) then return false end
				if c==nil then return true end
				return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
					and (Duel.IsExistingMatchingCard(Auxiliary.SpacetSummonFilter,c:GetControler(),loc,0,1,nil,cd)
					or Duel.IsExistingMatchingCard(Auxiliary.SpacetSummonSubstitute,c:GetControler(),LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,cd,c:GetControler()))
			end
end
function Auxiliary.SpacetSummonTarget(cd,loc)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c)
				local g=Duel.GetMatchingGroup(Auxiliary.SpacetSummonFilter,tp,loc,0,nil,cd)
				g:Merge(Duel.GetMatchingGroup(Auxiliary.SpacetSummonSubstitute,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,c:GetControler()))
				local sg=aux.SelectUnselectGroup(g,e,tp,1,1,aux.ChkfMMZ(1),1,tp,HINTMSG_REMOVE,nil,nil,true)
				if #sg>0 then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				end
				return false
			end
end
function Auxiliary.SpacetSummonOperation(cd,loc)
	return	function(e,tp,eg,ep,ev,re,r,rp,c)
				local g=e:GetLabelObject()
				if not g then return end
				local tc=g:GetFirst()
				if tc:IsHasEffect(52401238,tp) then tc:IsHasEffect(52401238,tp):UseCountLimit(tp) end
				Duel.Remove(tc,POS_FACEUP,REASON_COST)
				g:DeleteGroup()
			end
end
