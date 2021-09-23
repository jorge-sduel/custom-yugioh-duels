ARMOR_SET_CODE		   = 0x700
CATEGORY_ATTACH_ARMOR  = 0x20000000
REASON_ARMORIZING	   = 0x40000000
SUMMON_TYPE_ARMORIZING = 0x40
FLAG_ARMOR_RESOLVED	   = 0x8000000
ARMOR_IMPORTED         = true
--[[
add at the start of the script to add Armor/Armorizing procedure
if not ARMOR_IMPORTED then dofile Duel.LoadScript("script\proc_armor.lua") end
condition if Armorizing summoned
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_TYPE_ARMORIZING
]]
--add procedure to armor cards
function Auxiliary.AttachArmor(c,ar)
	if Duel.Overlay(c,ar)~=0 then
		c:RegisterFlagEffect(FLAG_ARMOR_RESOLVED,RESET_CHAIN,0,1)
	end
end
function Auxiliary.AddArmorProcedure(c,f,efftype,category,property,zone,hint1,hint2,con,cost,tg)
	--Attach
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(c:GetCode(),0))
	if efftype then
		e1:SetType(efftype)
	--elseif c:IsType(TYPE_SPELL) then
		--e1:SetType(EFFECT_TYPE_ACTIVATE)
	else
		e1:SetType(EFFECT_TYPE_IGNITION)
	end
	e1:SetCode(EVENT_FREE_CHAIN)
	if zone then
		e1:SetRange(zone)
	else--if not c:IsType(TYPE_SPELL) then
		e1:SetRange(LOCATION_HAND)
	end
	if hint1 or hint2 then
		if hint1==hint2 then
			e1:SetHintTiming(hint1)
		elseif hint1 and not hint2 then
			e1:SetHintTiming(hint1,0)
		elseif hint2 and not hint1 then
			e1:SetHintTiming(0,hint2)
		else
			e1:SetHintTiming(hint1,hint2)
		end
	end
	if category then
		e1:SetCategory(CATEGORY_ATTACH_ARMOR+category)
	else
		e1:SetCategory(CATEGORY_ATTACH_ARMOR)
	end
	if property then
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET+property)
	else
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	end
	if con then e1:SetCondition(con) end
	if cost then e1:SetCost(cost) end
	e1:SetTarget(Auxiliary.ArmorTarget(tg,f))
	e1:SetOperation(Auxiliary.ArmorOperation)
	c:RegisterEffect(e1)
end
function Auxiliary.ArmorFilter(c,f,e,tp,tg,eg,ep,ev,re,r,rp)
	return not c:IsType(TYPE_XYZ) and c:IsControler(tp) and c:IsFaceup() and (not f or f(c,e,tp)) and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,c,0))
end
function Auxiliary.ArmorTarget(tg,f)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
				if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and Auxiliary.ArmorFilter(chkc,f,e,tp) end
				if chk==0 then return Duel.IsExistingTarget(Auxiliary.ArmorFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,f,e,tp,tg,eg,ep,ev,re,r,rp) end
				--	and e:GetHandler():GetFlagEffect(c)==0 end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
				local g=Duel.SelectTarget(tp,Auxiliary.ArmorFilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,f,e,tp)
				Duel.SetOperationInfo(0,CATEGORY_ATTACH_ARMOR,g,1,0,0)
				if tg then tg(e,tp,eg,ep,ev,re,r,rp,g:GetFirst(),1) end
			end
end
function Auxiliary.ArmorOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		if c:IsType(TYPE_SPELL+TYPE_TRAP) then c:CancelToGrave() end
		Auxiliary.AttachArmor(tc,Group.FromCards(c))
	end
end
function Auxiliary.ArmorCondition(e)
	return not e:GetHandler():IsType(TYPE_XYZ)
end

--Armorizing Summon
function Auxiliary.AddArmorizingProcedure(c,f1,armor)
	if c.armorizing_filter==nil then
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		mt.minarmorizingct=ct
		mt.maxarmorizingct=maxct
		mt.armorizing_type=1
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	--e1:SetDescription("Armorizing Summon")
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Auxiliary.ArmorizingCondition(f1,armor))
	e1:SetTarget(Auxiliary.ArmorizingTarget(f1,armor))
	e1:SetOperation(Auxiliary.ArmorizingOperation)
	e1:SetValue(SUMMON_TYPE_ARMORIZING)
	c:RegisterEffect(e1)
end

function Auxiliary.ArmorizingMatFilter(c,f1,sc,tp,armor)
	local g=Group.CreateGroup()
	g:AddCard(c)
	return c:IsFaceup() and not c:IsType(TYPE_XYZ) and c:GetOverlayCount()>=armor
		and (not f1 or f1(c,sc,SUMMON_TYPE_SPECIAL,tp))
        and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function Auxiliary.ArmorizingCheck(sg,e,tp,mg,f1,sc,armor)
	return sg:IsExists(Auxiliary.ArmorizingMatFilter,1,nil,f1,sc,tp,armor)
end
function Auxiliary.ArmorizingCondition(f1,armor)
	return	function(e,c)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				
				return Duel.IsExistingMatchingCard(Auxiliary.ArmorizingMatFilter,tp,LOCATION_MZONE,0,1,nil,f1,c,tp,armor)
				--local g=Duel.GetMatchingGroup(Auxiliary.ArmorizingMatFilter,tp,LOCATION_MZONE,0,nil,f1,c,tp,armor)
				--return aux.SelectUnselectGroup(g,e,tp,1,1,Auxiliary.ArmorizingCheck,0,f1,c,armor)
            end
end
function Auxiliary.ArmorizingTarget(f1,armor)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
                local c=e:GetHandler()
				local tp=e:GetHandlerPlayer()
                
                --Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
				--local mg=Duel.SelectMatchingCard(tp,Auxiliary.ArmorizingMatFilter,tp,LOCATION_MZONE,0,1,1,nil,f1,c,tp,armor)
				local rg=Duel.GetMatchingGroup(Auxiliary.ArmorizingMatFilter,tp,LOCATION_MZONE,0,nil,f1,c,tp,armor)
				local mg=aux.SelectUnselectGroup(rg,e,tp,1,1,nil,1,tp,HINTMSG_SELECT,nil,nil,true,f1,c,armor)
                
				if #mg>0 then
					local sg=mg:GetFirst():GetOverlayGroup()
					sg:Merge(mg)
							  
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else
					return false
				end
            end
end
Auxiliary.ArmorizingSend=0
function Auxiliary.ArmorizingOperation(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	if Auxiliary.ArmorizingSend==1 then
		Duel.SendtoGrave(g,REASON_MATERIAL+REASON_ARMORIZING+REASON_RETURN)
	elseif Auxiliary.ArmorizingSend==2 then
		Duel.Remove(g,POS_FACEUP,REASON_MATERIAL+REASON_ARMORIZING)
	elseif Auxiliary.ArmorizingSend==3 then
		Duel.Remove(g,POS_FACEDOWN,REASON_MATERIAL+REASON_ARMORIZING)
	elseif Auxiliary.ArmorizingSend==4 then
		Duel.SendtoHand(g,nil,REASON_MATERIAL+REASON_ARMORIZING)
	elseif Auxiliary.ArmorizingSend==5 then
		Duel.SendtoDeck(g,nil,2,REASON_MATERIAL+REASON_ARMORIZING)
	elseif Auxiliary.ArmorizingSend==6 then
		Duel.Destroy(g,REASON_MATERIAL+REASON_ARMORIZING)
	else
		Duel.SendtoGrave(g,REASON_MATERIAL+REASON_ARMORIZING)
	end
	g:DeleteGroup()
	c:RegisterFlagEffect(SUMMON_TYPE_SPECIAL,RESETS_STANDARD,0,1)
end