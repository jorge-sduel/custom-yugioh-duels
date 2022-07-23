EFFECT_HAND_EVOLUTE	= 6011000
REASON_EVOLUTE		= 0x1600
SUMMON_TYPE_EVOLUTE 	= 0x1600
HINTMSG_EVMATERIAL	= 1600000
EVOLUTE_IMPORTED	= true
if not aux.EvoluteProcedure then
	aux.EvoluteProcedure = {}
	Evolute = aux.EvoluteProcedure
end
if not Evolute then
	Evolute = aux.EvoluteProcedure
end
--[[
add at the start of the script to add Evolute procedure
if not EVOLUTE_IMPORTED then Duel.LoadScript("proc_evolute.lua") end
condition if Evolute summoned
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_TYPE_EVOLUTE
]]
--Evolute Summon
function Evolute.AddProcedure(c,f,min,max,specialchk,opp,loc,send)
    -- opp==true >> you can use opponent monsters as materials (default false)
    -- loc default LOCATION_MZONE
	-- send materials:
	-- 1 >> grave
	-- 2 >> remove face-up
	-- 3 >> remove face-down
	-- 4 >> hand
	-- 5 >> deck
	-- 6 >> destroy
	if loc==nil then loc=LOCATION_MZONE+LOCATION_HAND end
	--if e:GetHandler():IsCode(221594325) then loc=LOCATION_HAND+LOCATION_MZONE end
	if c.evolute_type==nil then
		local mt=c:GetMetatable()
		mt.evolute_type=1
		mt.evolute_parameters={c,f,min,max,control,location,operation}
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetDescription(1181)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Evolute.Condition(f,min,max,specialchk,opp,loc,send))
	e1:SetTarget(Evolute.Target(f,min,max,specialchk,opp,loc,send))
	e1:SetOperation(Evolute.Operation(f,min,max,specialchk,opp,loc,send))
    e1:SetValue(SUMMON_TYPE_EVOLUTE)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1600058,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCondition(Evolute.sumcon)
	--e2:SetTarget(Evolute.addct)
	e2:SetOperation(Evolute.addc)
	c:RegisterEffect(e2)
	--remove Synchro type
	local ea=Effect.CreateEffect(c)
	ea:SetType(EFFECT_TYPE_SINGLE)
	ea:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	ea:SetRange(0x3ff)
	ea:SetCode(EFFECT_REMOVE_TYPE)
	ea:SetValue(TYPE_SYNCHRO)
	c:RegisterEffect(ea)
end
function Card.IsEvolute(c)
	return c.Is_Evolute
end
function Card.IsEvoluteTuner(c)
	return c.Is_Evolute and c:IsType(TYPE_TUNER)
end
function Evolute.IsLocation(c,e,loc,loc1)
	if loc==nil then loc1=LOCATION_MZONE end
	--if c:IsCode(221594325) then loc1=LOCATION_HAND end
	return ((c:IsLocation(loc1) and c:IsFaceup()) or c:IsHasEffect(16000820,tp)) and not c:IsType(TYPE_LINK)
end
function Evolute.ConditionFilter(c,f,lc,tp)
	return (not f or f(c,lc,SUMMON_TYPE_SPECIAL,tp)) and not c:IsHasEffect(50031787,tp)
end
function Evolute.GetEvoluteCount(c)
    if c:GetLevel()>=1 then return c:GetLevel()
    elseif c:GetRank()>=1 then return c:GetRank() end
    return 1
end
function Evolute.CheckRecursive(c,tp,sg,mg,lc,minc,maxc,f,specialchk,og,emt,filt)
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
	local res=Evolute.CheckGoal(tp,sg,lc,minc,f,specialchk,filt)
		or (#sg<maxc and mg:IsExists(Evolute.CheckRecursive,1,sg,tp,sg,mg,lc,minc,maxc,f,specialchk,og,emt,{table.unpack(filt)}))
	sg:RemoveCard(c)
	return res
end
function Evolute.CheckRecursive2(c,tp,sg,sg2,secondg,mg,lc,minc,maxc,f,specialchk,og,emt,filt)
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
			local res=secondg:IsExists(Evolute.CheckRecursive,1,sg,tp,sg,mg,lc,minc,maxc,f,specialchk,og,emt,{table.unpack(filt)})
			sg:RemoveCard(c)
			return res
		else
			local res=Evolute.CheckGoal(tp,sg,lc,minc,f,specialchk,{table.unpack(filt)})
			sg:RemoveCard(c)
			return res
		end
	end
	local res=Evolute.CheckRecursive2((sg2-sg):GetFirst(),tp,sg,sg2,secondg,mg,lc,minc,maxc,f,specialchk,og,emt,filt)
	sg:RemoveCard(c)
	return res
end
function Evolute.CheckGoal(tp,sg,lc,minc,f,specialchk,filt)
	for _,filt in ipairs(filt) do
		if not sg:IsExists(filt[2],1,nil,filt[3],tp,sg,Group.CreateGroup(),lc,filt[1],1) then
			return false
		end
	end
	return #sg>=minc and sg:CheckWithSumEqual(Evolute.GetEvoluteCount,lc:GetLevel(),#sg,#sg)
		and (not specialchk or specialchk(sg,lc,SUMMON_TYPE_SPECIAL,tp)) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0
end
function Evolute.Condition(f,minc,maxc,specialchk,opp,loc,send)
	return	function(e,c,must,g,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local loc2=0
				if opp then loc2=loc end
				if not g then
					g=Duel.GetMatchingGroup(Evolute.IsLocation,tp,loc,loc2,nil)
				end
				local mg=g:Filter(Evolute.ConditionFilter,nil,f,c,tp)
				local mustg=Auxiliary.GetMustBeMaterialGroup(tp,g,tp,c,mg,REASON_EVOLUTE)
				if must then mustg:Merge(must) end
				if min and min < minc then return false end
				if max and max > maxc then return false end
				min = min or minc
				max = max or maxc
				if mustg:IsExists(aux.NOT(Evolute.ConditionFilter),1,nil,f,c,tp) or #mustg>max then return false end
				local emt,tg=aux.GetExtraMaterials(tp,mustg+mg,c,LOCATION_HAND)
				tg=tg:Filter(Evolute.ConditionFilter,nil,f,c,tp)
				local res=(mg+tg):Includes(mustg) and #mustg<=max
				if res then
					if #mustg==max then
						local sg=Group.CreateGroup()
						res=mustg:IsExists(Evolute.CheckRecursive,1,sg,tp,sg,(mg+tg),c,min,max,f,specialchk,mg,emt)
					elseif #mustg<max then
						local sg=mustg
						res=(mg+tg):IsExists(Evolute.CheckRecursive,1,sg,tp,sg,(mg+tg),c,min,max,f,specialchk,mg,emt)
					end
				end
				aux.DeleteExtraMaterialGroups(emt)
				return res
			end
end
function Evolute.Target(f,minc,maxc,specialchk,opp,loc,send)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c,must,g,min,max)
				local loc2=0
				if opp then loc2=loc end
				if not g then
					g=Duel.GetMatchingGroup(Evolute.IsLocation,tp,loc,loc2,nil)
				end
				if min and min < minc then return false end
				if max and max > maxc then return false end
				min = min or minc
				max = max or maxc
				local mg=g:Filter(Evolute.ConditionFilter,nil,f,c,tp)
				local mustg=Auxiliary.GetMustBeMaterialGroup(tp,g,tp,c,mg,REASON_EVOLUTE)
				if must then mustg:Merge(must) end
				local emt,tg=aux.GetExtraMaterials(tp,mustg+mg,c,EFFECT_HAND_EVOLUTE)
				tg=tg:Filter(Evolute.ConditionFilter,nil,f,c,tp)
				local sg=Group.CreateGroup()
				local finish=false
				local cancel=false
				sg:Merge(mustg)
				while #sg<max do
					local filters={}
					if #sg>0 then
						Evolute.CheckRecursive2(sg:GetFirst(),tp,Group.CreateGroup(),sg,mg+tg,mg+tg,c,min,max,f,specialchk,mg,emt,filters)
					end
					local cg=(mg+tg):Filter(Evolute.CheckRecursive,sg,tp,sg,(mg+tg),c,min,max,f,specialchk,mg,emt,{table.unpack(filters)})
					if #cg==0 then break end
					finish=#sg>=min and #sg<=max and Evolute.CheckGoal(tp,sg,c,min,f,specialchk,filters)
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
					Evolute.CheckRecursive2(sg:GetFirst(),tp,Group.CreateGroup(),sg,mg+tg,mg+tg,c,min,max,f,specialchk,mg,emt,filters)
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
function Evolute.Operation(f,minc,maxc,specialchk,opp,loc,send)
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
					Duel.SendtoGrave(g,REASON_MATERIAL+REASON_EVOLUTE+REASON_RETURN)
				elseif send==2 then
					Duel.Remove(g,POS_FACEUP,REASON_MATERIAL+REASON_EVOLUTE)
				elseif send==3 then
					Duel.Remove(g,POS_FACEDOWN,REASON_MATERIAL+REASON_EVOLUTE)
				elseif send==4 then
					Duel.SendtoHand(g,nil,REASON_MATERIAL+REASON_EVOLUTE)
				elseif send==5 then
					Duel.SendtoDeck(g,nil,2,REASON_MATERIAL+REASON_EVOLUTE)
				elseif send==6 then
					Duel.Destroy(g,REASON_MATERIAL+REASON_EVOLUTE)
				else
					Duel.SendtoGrave(g,REASON_MATERIAL+REASON_EVOLUTE)
				end
				g:DeleteGroup()
				aux.DeleteExtraMaterialGroups(emt)
			end
end
function Evolute.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x88)
end
function Evolute.addc(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x111f,e:GetHandler():GetLevel())
end
--function Evolute.addc(e,tp,eg,ep,ev,re,r,rp)
	--if e:GetHandler():IsRelateToEffect(e) then
		--e:GetHandler():AddCounter(0x88,e:GetHandler():GetLevel())
	--end
--end
function Evolute.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_EVOLUTE)
end
--function Auxiliary.EvoluteSummonSubstitute(c,f,lc,tp)
--	return not f or f(c,lc,SUMMON_TYPE_SPECIAL,tp) and c:IsHasEffect(16000820,tp)
--end
--Summon Evolute used 1 monster only
function Auxiliary.AddEvoluteSummonProcedure(c,code,loc,excon)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
    e1:SetValue(SUMMON_TYPE_EVOLUTE)
	e1:SetCondition(Auxiliary.EvoluteSummonCondition(code,loc,excon))
	e1:SetTarget(Auxiliary.EvoluteSummonTarget(code,loc))
	e1:SetOperation(Auxiliary.EvoluteSummonOperation(code,loc))
	c:RegisterEffect(e1)
end
function Auxiliary.EvoluteSummonFilter(c,cd)
	return not cd or cd(c,lc,SUMMON_TYPE_SPECIAL,tp)
end
function Auxiliary.EvoluteSummonSubstitute(c,cd,tp)
	return c:IsHasEffect(4882946100,tp) and c:IsAbleToGraveAsCost()
end
function Auxiliary.EvoluteSummonCondition(cd,loc,excon)
	return 	function(e,c)
				if excon and not excon(e,c) then return false end
				if c==nil then return true end
				return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
					and (Duel.IsExistingMatchingCard(Auxiliary.EvoluteSummonFilter,c:GetControler(),loc,0,1,nil,cd)
					or Duel.IsExistingMatchingCard(Auxiliary.EvoluteSummonSubstitute,c:GetControler(),LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,cd,c:GetControler()))
			end
end
function Auxiliary.EvoluteSummonTarget(cd,loc)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c)
				local g=Duel.GetMatchingGroup(Auxiliary.EvoluteSummonFilter,tp,loc,0,nil,cd)
				g:Merge(Duel.GetMatchingGroup(Auxiliary.EvoluteSummonSubstitute,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,c:GetControler()))
				local sg=aux.SelectUnselectGroup(g,e,tp,1,1,aux.ChkfMMZ(1),1,tp,HINTMSG_REMOVE,nil,nil,true)
				if #sg>0 then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				end
				return false
			end
end
function Auxiliary.EvoluteSummonOperation(cd,loc)
	return	function(e,tp,eg,ep,ev,re,r,rp,c)
				local g=e:GetLabelObject()
				if not g then return end
				local tc=g:GetFirst()
				if tc:IsHasEffect(4882946100,tp) then tc:IsHasEffect(48829461,tp):UseCountLimit(tp) end
		c:SetMaterial(tc)
				Duel.SendtoGrave(tc,REASON_MATERIAL+REASON_EVOLUTE)
				g:DeleteGroup()
			end
end
--Convergent evolute
function Auxiliary.AddConvergentEvolSummonProcedure(c,code,loc,excon)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
    e1:SetValue(SUMMON_TYPE_EVOLUTE)
	e1:SetCondition(Auxiliary.ConvergentEvolSummonCondition(code,loc,excon))
	e1:SetTarget(Auxiliary.ConvergentEvolSummonTarget(code,loc))
	e1:SetOperation(Auxiliary.ConvergentEvolSummonOperation(code,loc))
	c:RegisterEffect(e1)
    --"Gain ATK"
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e0:SetCode(EVENT_SPSUMMON_SUCCESS)
    e0:SetCondition(Auxiliary.ConvergentEvolatkcon)
    e0:SetOperation(Auxiliary.ConvergentEvolatkop)
    c:RegisterEffect(e0)
end
function Auxiliary.ConvergentEvolSummonFilter(c,cd)
	return (not cd or cd(c,lc,SUMMON_TYPE_SPECIAL,tp)) or c.Is_Evolute
end
function Auxiliary.ConvergentEvolSummonSubstitute(c,cd,tp)
	return c:IsHasEffect(48829461,tp) and c:IsAbleToGraveAsCost()
end
function Auxiliary.ConvergentEvolSummonCondition(cd,loc,excon)
	return 	function(e,c)
				if excon and not excon(e,c) then return false end
				if c==nil then return true end
				return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
					and (Duel.IsExistingMatchingCard(Auxiliary.ConvergentEvolSummonFilter,c:GetControler(),loc,0,1,nil,cd)
					or Duel.IsExistingMatchingCard(Auxiliary.ConvergentEvolSummonSubstitute,c:GetControler(),LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil,cd,c:GetControler()))
			end
end
function Auxiliary.ConvergentEvolSummonTarget(cd,loc)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,c)
				local g=Duel.GetMatchingGroup(Auxiliary.ConvergentEvolSummonFilter,tp,loc,0,nil,cd)
				g:Merge(Duel.GetMatchingGroup(Auxiliary.ConvergentEvolSummonSubstitute,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,c:GetControler()))
				local sg=aux.SelectUnselectGroup(g,e,tp,1,99,aux.ChkfMMZ(1),1,tp,HINTMSG_REMOVE,nil,nil,true)
				if #sg>0 then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				end
				return false
			end
end
function Auxiliary.ConvergentEvolSummonOperation(cd,loc)
	return	function(e,tp,eg,ep,ev,re,r,rp,c)
				local g=e:GetLabelObject()
				if not g then return end
		c:SetMaterial(g)
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_EVOLUTE)
				g:DeleteGroup()
			end
end
function Auxiliary.ConvergentEvolatkcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():IsSummonType(SUMMON_TYPE_EVOLUTE)
end
function Auxiliary.ConvergentEvolatkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=c:GetMaterial()
    local lv=0
    local tc=g:GetFirst()
    while tc do
        local lv2=tc:GetLevel()
        lv=lv+lv2
        tc=g:GetNext()
    end
    e:GetHandler():AddCounter(0x111f,lv)
end
function Auxiliary.AddEcProcedure(c,cd)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1600058,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCondition(function(e) return e:GetHandler():GetSummonType()==cd end)
	--e2:SetTarget(Evolute.addct)
	e2:SetOperation(Auxiliary.addEc)
	c:RegisterEffect(e2)
end
function Auxiliary.sumcon2(c,e,cd)
	return c:GetSummonType()==cd
end
function Auxiliary.addEc(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
	e:GetHandler():AddCounter(0x111f,e:GetHandler():GetLevel())
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(160001126)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
end
function Auxiliary.EvoluteStage(c,tp)
	return c:IsHasEffect(160001126,tp)
end
