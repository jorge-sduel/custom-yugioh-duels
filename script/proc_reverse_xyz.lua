REVERSE_XYZ_IMPORTED=true
if not aux.ReverseXyzProcedure then
	aux.ReverseXyzProcedure = {}
	ReverseXyz = aux.ReverseXyzProcedure
end
if not ReverseXyz then
	ReverseXyz = aux.ReverseXyzProcedure
end
--[[
add at the start of the script to add Ingition procedure
if not REVERSE_XYZ_IMPORTED then Duel.LoadScript("proc_reverse_xyz.lua") end
]]
--ReverseXyz Summon
function ReverseXyz.AddProcedure(c,f1,f2,lv)
	if lv==nil then lv=c:GetOriginalRank() end
    if f2==nil then f2=f1 end
	if c.rxyz_filter==nil then
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		mt.rxyz_type=1
		mt.rxyz_filter=function(mc,ignoretoken) return mc and (not f or f(mc)) and (mc:IsXyzLevel(c,lv) or mc:IsXyzLevel(c,lv*2)) and (not mc:IsType(TYPE_TOKEN) or ignoretoken) end
		mt.rxyz_parameters={mt.rxyz_filter,c,f1,f2,lv}
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetDescription(1180)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(ReverseXyz.Condition(f1,f2,lv))
	e1:SetTarget(ReverseXyz.Target(f1,f2,lv))
	e1:SetOperation(ReverseXyz.Operation)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
end
function ReverseXyz.FilterEx(c,f,sc,tp,lv,mg)
    local g=mg
    g:AddCard(c)
	return c:IsXyzLevel(sc,lv) and (not f or f(c,sc,SUMMON_TYPE_XYZ,tp))
        and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function ReverseXyz.Filter(c,f1,sc,tp,lv)
	return c:IsFaceup() and not c:IsType(TYPE_TOKEN) and c:IsXyzLevel(sc,lv)
        and (not f1 or f1(c,sc,SUMMON_TYPE_XYZ,tp)) 
end
function ReverseXyz.Check(tp,sg,sc,f1,f2,lv)
	return sg:IsExists(ReverseXyz.FilterEx,1,nil,f1,sc,tp,lv,sg)
		and sg:IsExists(ReverseXyz.FilterEx,1,nil,f2,sc,tp,lv*2,sg)
end
function ReverseXyz.Condition(f1,f2,lv)
	return	function(e,c)
				if c==nil then return true end
				local tp=c:GetControler()
                
                if not Duel.IsExistingMatchingCard(ReverseXyz.Filter,tp,LOCATION_MZONE,0,1,nil,f1,c,tp,lv)
                    or not Duel.IsExistingMatchingCard(ReverseXyz.Filter,tp,LOCATION_MZONE,0,1,nil,f2,c,tp,lv*2) then return false end
                
                local mg1=Duel.GetMatchingGroup(ReverseXyz.Filter,tp,LOCATION_MZONE,0,nil,f1,c,tp,lv)
                local mg2=Duel.GetMatchingGroup(ReverseXyz.Filter,tp,LOCATION_MZONE,0,nil,f2,c,tp,lv*2)
                
                if #mg1<=0 or #mg2<=0 then return false end
                
                return mg1:IsExists(ReverseXyz.FilterEx,1,nil,f1,c,tp,lv,mg2)
                    and mg2:IsExists(ReverseXyz.FilterEx,1,nil,f2,c,tp,lv*2,mg1)
            end
end
function ReverseXyz.Target(f1,f2,lv)
	return function(e,tp,eg,ep,ev,re,r,rp,chk,c,must,mg1,mg2)
                if not mg1 then
                    mg1=Duel.GetMatchingGroup(ReverseXyz.Filter,tp,LOCATION_MZONE,0,nil,f1,c,tp,lv)
                end
                if not mg2 then
                    mg2=Duel.GetMatchingGroup(ReverseXyz.Filter,tp,LOCATION_MZONE,0,nil,f2,c,tp,lv*2)
                end

				local mustg=Auxiliary.GetMustBeMaterialGroup(tp,mg1+mg2,tp,c,mg1+mg2,REASON_XYZ)
				if must then mustg:Merge(must) end                
				local sg=Group.CreateGroup()
				local finish=false
				local cancel=false
				sg:Merge(mustg)
				while #sg<2 do                    
					local cg=Group.CreateGroup()
                    if not sg:IsExists(ReverseXyz.FilterEx,1,nil,f1,c,tp,lv,mg2) then
                        cg=mg1:Filter(ReverseXyz.FilterEx,nil,f1,c,tp,lv,mg2)
                    elseif not sg:IsExists(ReverseXyz.FilterEx,1,nil,f2,c,tp,lv*2,mg1) then
                        cg=mg2:Filter(ReverseXyz.FilterEx,nil,f2,c,tp,lv*2,mg1)
                    end
					if #cg==0 then break end
					finish=#sg==max and ReverseXyz.Check(tp,sg,c,f1,f2,lv)
					cancel=Duel.GetCurrentChain()<=0 and #sg==0
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					local tc=Group.SelectUnselect(cg,sg,tp,finish,cancel,1,1)
					if not tc then break end
					if not sg:IsContains(tc) then
						sg:AddCard(tc)
					else
						sg:RemoveCard(tc)
					end
				end
				
				if #sg>0 then
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else
					return false
				end
            end
end
function ReverseXyz.Operation(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
    local c=e:GetHandler()
	local g=e:GetLabelObject()
	c:SetMaterial(g)
    Duel.Overlay(c,g)
	g:DeleteGroup()
end