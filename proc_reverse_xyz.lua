REVERSE_XYZ_IMPORTED=true
--[[
if not REVERSE_XYZ_IMPORTED then
  dofile "script/proc_reverse_xyz.lua"
end
    aux.AddReverseXyzProcedure(c,FILTER)
]]
--ReverseXyz monster
function Auxiliary.AddReverseXyzProcedure(c,f1,f2)
    if f2==nil then f2=f1 end
	if c.rxyz_filter==nil then
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		mt.rxyz_type=1
		mt.rxyz_parameters={mt.rxyz_filter,c,f1,f2}
		mt.rxyz_filter=function(mc,ignoretoken) return mc and (not f or f(mc)) and mc:IsXyzLevel(c,lv) and (not mc:IsType(TYPE_TOKEN) or ignoretoken) end
		mt.rxyz_parameters={mt.xyz_filter,c,f1,f2}
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetDescription("Reverse Xyz Summon")
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Auxiliary.ReverseXyzCondition(f1,f2))
	e1:SetTarget(Auxiliary.ReverseXyzTarget(f1,f2))
	e1:SetOperation(Auxiliary.ReverseXyzOperation)
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
end
function Auxiliary.RXyzMat1FilterEx(c,f1,sc,tp,lv,mg)
    --local g=Duel.GetMatchingGroup(Auxiliary.RXyzMat2Filter,tp,LOCATION_MZONE,0,nil,mg,c,tp,lv)
    local g=mg
    g:AddCard(c)
	return c:IsXyzLevel(sc,lv) and (not f1 or f1(c,sc,SUMMON_TYPE_XYZ,tp))
        and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function Auxiliary.RXyzMat2FilterEx(c,f2,sc,tp,lv,mg)
    --local g=Duel.GetMatchingGroup(Auxiliary.RXyzMat1Filter,tp,LOCATION_MZONE,0,nil,mg,c,tp,lv)
    local g=mg
    g:AddCard(c)
	return c:IsXyzLevel(sc,lv*2) and (not f2 or f2(c,sc,SUMMON_TYPE_XYZ,tp))
        and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function Auxiliary.RXyzMat1Filter(c,f1,sc,tp,lv)
	return c:IsFaceup() and not c:IsType(TYPE_TOKEN) and c:IsXyzLevel(sc,lv)
        and (not f1 or f1(c,sc,SUMMON_TYPE_XYZ,tp)) 
end
function Auxiliary.RXyzMat2Filter(c,f2,sc,tp,lv)
	return c:IsFaceup() and not c:IsType(TYPE_TOKEN) and c:IsXyzLevel(sc,lv*2)
        and (not f2 or f2(c,sc,SUMMON_TYPE_XYZ,tp)) 
end
function Auxiliary.ReverseXyzCondition(f1,f2)
	return	function(e,c)
				if c==nil then return true end
				local tp=c:GetControler()
				local lv=c:GetRank()
                
                if not Duel.IsExistingMatchingCard(Auxiliary.RXyzMat1Filter,tp,LOCATION_MZONE,0,1,nil,f1,c,tp,lv)
                    or not Duel.IsExistingMatchingCard(Auxiliary.RXyzMat2Filter,tp,LOCATION_MZONE,0,1,nil,f2,c,tp,lv) then return false end
                
                local mg1=Duel.GetMatchingGroup(Auxiliary.RXyzMat1Filter,tp,LOCATION_MZONE,0,nil,f1,c,tp,lv)
                local mg2=Duel.GetMatchingGroup(Auxiliary.RXyzMat2Filter,tp,LOCATION_MZONE,0,nil,f2,c,tp,lv)
                
                if mg1:GetCount()<=0 or mg2:GetCount()<=0 then return false end
                
                return mg1:IsExists(Auxiliary.RXyzMat1FilterEx,1,nil,f1,c,tp,lv,mg2)
                    and mg2:IsExists(Auxiliary.RXyzMat2FilterEx,1,nil,f2,c,tp,lv,mg1)
            end
end
function Auxiliary.ReverseXyzTarget(f1,f2)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
                local c=e:GetHandler()
				local tp=e:GetHandlerPlayer()
				local lv=e:GetHandler():GetRank()
                
                Duel.Hint(HINT_SELECTMSG,tp,"Select a card to use as Reverse Xyz Material")
                local mg1=Duel.GetMatchingGroup(Auxiliary.RXyzMat1Filter,tp,LOCATION_MZONE,0,nil,f1,c,tp,lv)
                local mg2=Duel.GetMatchingGroup(Auxiliary.RXyzMat2Filter,tp,LOCATION_MZONE,0,nil,f2,c,tp,lv)
                
                local sg1=mg1:FilterSelect(tp,Auxiliary.RXyzMat1FilterEx,1,1,nil,f1,c,tp,lv,mg2)
                local sg2=mg2:FilterSelect(tp,Auxiliary.RXyzMat2FilterEx,1,1,nil,f2,c,tp,lv,mg1)
                sg1:Merge(sg2)            
                sg1:KeepAlive()
                e:SetLabelObject(sg1)
                return true
            end
end
function Auxiliary.ReverseXyzOperation(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
    local c=e:GetHandler()
	local g=e:GetLabelObject()
	c:SetMaterial(g)
    Duel.Overlay(c,g)
	g:DeleteGroup()
end