ARMOR_IMPORTED			= true
CATEGORY_ATTACH_ARMOR	= 0x20000000
REASON_ARMORIZING		= 0x40000000
SUMMON_TYPE_ARMORIZING	= 0x40
EFFECT_FLAG_ARMOR		= 0x20000000
HINTMSG_AMATERIAL       = 602
HINTMSG_REMOVEARMOR     = 603
HINTMSG_REMOVEARMORFROM = 604
HINTMSG_ARMORTARGET     = 605
HINTMSG_ATTACHARMOR     = 606
if not aux.ArmorProcedure then
	aux.ArmorProcedure = {}
	Armor = aux.ArmorProcedure
end
if not Armor then
	Armor = aux.ArmorProcedure
end
--[[
add at the start of the script to add Armor/Armorizing procedure
if not ARMOR_IMPORTED then dofile Duel.LoadScript("proc_armor.lua") end
condition if Armorizing summoned
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_TYPE_ARMORIZING
]]
--attach armor function
function Armor.AttachCheck(ar,c)
	return ar.IsArmor and c:IsFaceup() and not c:IsType(TYPE_XYZ) and (ar.AttachFilter == nil or ar.AttachFilter(c))
end
function Armor.Attach(c,ar)
	Duel.Overlay(c,ar)
end
--add procedure to armor cards
function Armor.AddProcedure(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1183)
	e1:SetCategory(CATEGORY_ATTACH_ARMOR)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(Armor.Target)
	e1:SetOperation(Armor.Operation)
	c:RegisterEffect(e1)
end
function Armor.Filter(c,e,tp)
	return not c:IsType(TYPE_XYZ) and c:IsFaceup()
		and (e:GetHandler().AttachFilter == nil or e:GetHandler().AttachFilter(c))
end
function Armor.Target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and Armor.Filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(Armor.Filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ARMORTARGET)
	local g=Duel.SelectTarget(tp,Armor.Filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_ATTACH_ARMOR,g,1,0,0)
end
function Armor.Operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		if c:IsType(TYPE_SPELL+TYPE_TRAP) then c:CancelToGrave() end
		Armor.Attach(tc,Group.FromCards(c))
	end
end
function Armor.Condition(e)
	return not e:GetHandler():IsType(TYPE_XYZ)
end

--Armorizing Summon
if not aux.ArmorizingProcedure then
	aux.ArmorizingProcedure = {}
	Armorizing = aux.ArmorizingProcedure
end
if not Armorizing then
	Armorizing = aux.ArmorizingProcedure
end
function Armorizing.AddProcedure(c,f1,min,f2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetDescription(1184)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Armorizing.Condition(f1,min,f2))
	e1:SetTarget(Armorizing.Target(f1,min,f2))
	e1:SetOperation(Armorizing.Operation)
	e1:SetValue(SUMMON_TYPE_ARMORIZING)
	c:RegisterEffect(e1)
end

function Armorizing.ArmorFilter(c,sc,tp,f1,min,f2)
	local g=Group.CreateGroup()
	g:AddCard(c)
	return c:IsFaceup() and not c:IsType(TYPE_XYZ)
		and c:GetOverlayCount()>=min
		and (not f2  or c:GetOverlayGroup():IsExists(f2,min,nil,e,tp))
		and (not f1 or f1(c,sc,SUMMON_TYPE_SPECIAL,tp))
        and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function Armorizing.MatFilter(c,sc,tp,f1,min,f2)
	local g=Group.CreateGroup()
	g:AddCard(c)
	return c:IsFaceup() and not c:IsType(TYPE_XYZ)
		and c:GetOverlayCount()>=min
		and (not f2 or c:GetOverlayGroup():IsExists(f2,min,nil,e,tp))
		and (not f1 or f1(c,sc,SUMMON_TYPE_SPECIAL,tp))
        and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function Armorizing.Check(sg,e,tp,mg,sc,f1,min,f2)
	return sg:IsExists(Armorizing.MatFilter,1,nil,sc,tp,f1,min,f2)
end
function Armorizing.Condition(f1,min,f2)
	return	function(e,c)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				
				return Duel.IsExistingMatchingCard(Armorizing.MatFilter,tp,LOCATION_MZONE,0,1,nil,c,tp,f1,min,f2)
				--local g=Duel.GetMatchingGroup(Armorizing.MatFilter,tp,LOCATION_MZONE,0,nil,f1,c,tp,armor)
				--return aux.SelectUnselectGroup(g,e,tp,1,1,Armorizing.Check,0,c)
            end
end
function Armorizing.Target(f1,min,f2)
	return	function(e,tp,eg,ep,ev,re,r,rp,chk)
                local c=e:GetHandler()
				local tp=e:GetHandlerPlayer()
                
                Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_AMATERIAL)
				local rg=Duel.GetMatchingGroup(Armorizing.MatFilter,tp,LOCATION_MZONE,0,nil,c,tp,f1,min,f2)
				local mg=aux.SelectUnselectGroup(rg,e,tp,1,1,nil,1,tp,HINTMSG_SELECT,nil,nil,true,c)
                
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
Armorizing.Send=0
function Armorizing.Operation(e,tp,eg,ep,ev,re,r,rp,c,smat,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	if Armorizing.Send==1 then
		Duel.SendtoGrave(g,REASON_MATERIAL+REASON_ARMORIZING+REASON_RETURN)
	elseif Armorizing.Send==2 then
		Duel.Remove(g,POS_FACEUP,REASON_MATERIAL+REASON_ARMORIZING)
	elseif Armorizing.Send==3 then
		Duel.Remove(g,POS_FACEDOWN,REASON_MATERIAL+REASON_ARMORIZING)
	elseif Armorizing.Send==4 then
		Duel.SendtoHand(g,nil,REASON_MATERIAL+REASON_ARMORIZING)
	elseif Armorizing.Send==5 then
		Duel.SendtoDeck(g,nil,2,REASON_MATERIAL+REASON_ARMORIZING)
	elseif Armorizing.Send==6 then
		Duel.Destroy(g,REASON_MATERIAL+REASON_ARMORIZING)
	else
		Duel.SendtoGrave(g,REASON_MATERIAL+REASON_ARMORIZING)
	end
	g:DeleteGroup()
	c:RegisterFlagEffect(SUMMON_TYPE_SPECIAL,RESETS_STANDARD,0,1)
end