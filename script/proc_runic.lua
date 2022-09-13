REASON_RUNIC		 = 0x128
SUMMON_TYPE_RUNIC = SUMMON_TYPE_SPECIAL+3880000
HINTMSG_RNMATERIAL	 = 60100000000000
RUNIC_IMPORTED    = true
if not aux.RunicProcedure then
	aux.RunicProcedure = {}
	Runic = aux.RunicProcedure
end
if not Runic then
	Runic = aux.RunicProcedure
end
--[[
add at the start of the script to add Runic procedure
if not RUNIC_IMPORTED then Duel.LoadScript("proc_runic.lua") end
condition if Runic summoned
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_TYPE_RUNIC
]]
--Runic Summon
function Runic.AddProcedure(c,f1,f2,min,max)
    --if min==nil then min=1 end
    --if max==nil then max=min end
	if c.runic_type==nil then
		local mt=c:GetMetatable()
		mt.runic_type=1
		mt.runic_parameters={c,f1,f2,min,max}
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetDescription(1182)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(Runic.Condition(f1,f2,min,max))
	e1:SetTarget(Runic.Target(f1,f2,min,max))
	e1:SetOperation(Runic.Operation)
    e1:SetValue(SUMMON_TYPE_RUNIC)
	c:RegisterEffect(e1)
--
       local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetCode(EFFECT_LEVEL_RANK)
	c:RegisterEffect(e8)
--
        local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetCode(EFFECT_CHANGE_LEVEL)
	e9:SetValue(0)
	c:RegisterEffect(e9)
--
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e10:SetCode(EFFECT_ALLOW_NEGATIVE)
	c:RegisterEffect(e10)
end
function Runic.FilterEx(c,f,sc,tp,mg,loc)
    local g=mg
    g:AddCard(c)
	return (not f or f(c,sc,SUMMON_TYPE_SPECIAL,tp))
        and (not loc or c:IsLocation(loc))
        and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
end
function Runic.Filter(c,f,sc,tp)
	return (not f or f(c,sc,SUMMON_TYPE_SPECIAL,tp)) 
end
function Runic.Check(tp,sg,sc,f1,f2,min)
	return sg:IsExists(Runic.FilterEx,1,nil,f1,sc,tp,sg,LOCATION_MZONE)
		and sg:IsExists(Runic.FilterEx,min,nil,f2,sc,tp,sg,LOCATION_ONFIELD)
end
function Runic.Remove(c,g)
	return g:IsContains(c)
end
function Runic.Condition(f1,f2,min,max)
	return	function(e,c)
				if c==nil then return true end
				local tp=c:GetControler()
                
                if not Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Runic.Filter),tp,LOCATION_MZONE,0,1,nil,f1,c,tp)
                    or not Duel.IsExistingMatchingCard(Runic.Filter,tp,LOCATION_ONFIELD,0,min,nil,f2,c,tp) then return false end
                
                local mg1=Duel.GetMatchingGroup(aux.FilterFaceupFunction(Runic.Filter),tp,LOCATION_MZONE,0,nil,f1,c,tp)
                local mg2=Duel.GetMatchingGroup(Runic.Filter,tp,LOCATION_ONFIELD,0,nil,f2,c,tp)
                
                if #mg1<=0 or #mg2<=0 then return false end
                return mg1:IsExists(Runic.FilterEx,1,nil,f1,c,tp,mg2)
                    and mg2:IsExists(Runic.FilterEx,min,nil,f2,c,tp,mg1)
            end
end
function Runic.Target(f1,f2,min,max)
	return function(e,tp,eg,ep,ev,re,r,rp,chk,c,must,mg1,mg2)
                if not mg1 then
                    mg1=Duel.GetMatchingGroup(aux.FilterFaceupFunction(Runic.Filter),tp,LOCATION_MZONE,0,nil,f1,c,tp)
                end
                if not mg2 then
                    mg2=Duel.GetMatchingGroup(Runic.Filter,tp,LOCATION_ONFIELD,0,nil,f2,c,tp)
                end
				local mustg=Auxiliary.GetMustBeMaterialGroup(tp,mg1+mg2,tp,c,mg1+mg2,REASON_RUNIC)
				if must then mustg:Merge(must) end                
				local sg=Group.CreateGroup()
				local finish=false
				local cancel=false
				sg:Merge(mustg)
				while #sg<(max+1) do
					local cg=Group.CreateGroup()
                    if not sg:IsExists(Runic.FilterEx,1,nil,f1,c,tp,mg2,LOCATION_MZONE) then
                        cg=mg1:Filter(Runic.FilterEx,nil,f1,c,tp,mg2,LOCATION_MZONE)
                    elseif not sg:IsExists(Runic.FilterEx,max,nil,f2,c,tp,mg1,LOCATION_ONFIELD) then
                        cg=mg2:Filter(Runic.FilterEx,nil,f2,c,tp,mg1,LOCATION_ONFIELD)
                    end
					cg:Remove(Runic.Remove,nil,sg)
					if #cg==0 then break end
					finish=#sg>=(min+1) and Runic.Check(tp,sg,c,f1,f2,min)
					cancel=Duel.GetCurrentChain()<=0 and #sg==0
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RNMATERIAL)
					local tc=Group.SelectUnselect(cg,sg,tp,finish,cancel,min+1,max+1)
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
function Runic.Operation(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_RUNIC)
	g:DeleteGroup()
end
-- Runic Summon by card effect
function Card.IsRunicSummonable(c,e,tp,must_use,mg)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,false,false)
		and c.Is_Runic and c:RunicRule(e,tp,must_use,mg)
end
function Card.RunicRule(c,e,tp,mustg,mg)
	local mt=c:GetMetatable()
	local f1=mt.runic_parameters[2]
	local f2=mt.runic_parameters[3]
	local min=mt.runic_parameters[4]
    local mg1=nil
    local mg2=nil
	if mg then
		mg1=mg:Filter(aux.FilterFaceupFunction(Card.IsLocation,LOCATION_MZONE),nil):Filter(Runic.Filter,nil,f1,c,tp)
		mg2=mg:Filter(Card.IsLocation,nil,LOCATION_ONFIELD):Filter(Runic.Filter,nil,f2,c,tp)
	else
		mg1=Duel.GetMatchingGroup(aux.FilterFaceupFunction(Runic.Filter),tp,LOCATION_MZONE,0,nil,f1,c,tp)
		mg2=Duel.GetMatchingGroup(Runic.Filter,tp,LOCATION_ONFIELD,0,nil,f2,c,tp)
	end
    if #mg1<=0 or #mg2<=0 then return false end
	if mustg and not Runic.FilterMustBeMat(mg1,mg2,mustg) then return false end
    return mg1:IsExists(Runic.FilterEx,1,nil,f1,c,tp,mg2)
        and mg2:IsExists(Runic.FilterEx,min,nil,f2,c,tp,mg1)
end
function Runic.FilterMustBeMat(mg1,mg2,mustg)
	local tc=mustg:GetFirst()
	while tc do
		if not mg1:IsContains(tc) and not mg2:IsContains(tc) then return false end
		tc=mustg:GetNext()
	end
	return true
end
function Duel.RunicSummon(c,tp,mustg,mg)
	local mt=c:GetMetatable()
	local f1=mt.runic_parameters[2]
	local f2=mt.runic_parameters[3]
	local min=mt.runic_parameters[4]
	local max=mt.runic_parameters[5]
    local mg1=nil
    local mg2=nil
	if mg then
		mg1=mg:Filter(aux.FilterFaceupFunction(Card.IsLocation,LOCATION_MZONE),nil):Filter(Runic.Filter,nil,f1,c,tp)
		mg2=mg:Filter(Card.IsLocation,nil,LOCATION_ONFIELD):Filter(Runic.Filter,nil,f2,c,tp)
	else
		mg1=Duel.GetMatchingGroup(aux.FilterFaceupFunction(Runic.Filter),tp,LOCATION_MZONE,0,nil,f1,c,tp)
		mg2=Duel.GetMatchingGroup(Runic.Filter,tp,LOCATION_ONFIELD,0,nil,f2,c,tp)
	end
	
	local sg=Group.CreateGroup()
	local finish=false
	local cancel=false
	if mustg then sg:Merge(mustg) end
	while #sg<(max+1) do
		local cg=Group.CreateGroup()
        if not sg:IsExists(Runic.FilterEx,1,nil,f1,c,tp,mg2,LOCATION_MZONE) then
        cg=mg1:Filter(Runic.FilterEx,nil,f1,c,tp,mg2,LOCATION_MZONE)
        elseif not sg:IsExists(Runic.FilterEx,max,nil,f2,c,tp,mg1,LOCATION_ONFIELD) then
            cg=mg2:Filter(Runic.FilterEx,nil,f2,c,tp,mg1,LOCATION_ONFIELD)
        end
		cg:Remove(Runic.Remove,nil,sg)
		if #cg==0 then break end
		finish=#sg>=(min+1) and Runic.Check(tp,sg,c,f1,f2,min)
		cancel=Duel.GetCurrentChain()<=0 and #sg==0
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RNMATERIAL)
		local tc=Group.SelectUnselect(cg,sg,tp,finish,cancel,min+1,max+1)
		if not tc then break end
		if not sg:IsContains(tc) then
			sg:AddCard(tc)
		else
			sg:RemoveCard(tc)
		end
	end
				
	if #sg>0 then
		c:SetMaterial(sg)
		Duel.SendtoGrave(sg,REASON_MATERIAL+REASON_RUNIC)
		Duel.SpecialSummon(c,SUMMON_TYPE_RUNIC,tp,tp,false,false,POS_FACEUP)
		c:CompleteProcedure()
	end
end
