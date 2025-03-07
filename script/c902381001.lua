--Shimzu Gyogun
local s,id=GetID()
s.Is_Runic=true
if not Rune then Duel.LoadScript("proc_rune.lua") end
function s.initial_effect(c)
	--rune
	c:EnableReviveLimit()
	Rune.AddProcedure(c,Rune.MonFunction(nil),1,1,Rune.STFunction(nil),1,1)
	--rune
	c:EnableReviveLimit()
   aux.AddRuneTuning2(c,LOCATION_MZONE,LOCATION_EXTRA,LOCATION_EXTRA)
	--level change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(84046493,0))
	e1:SetCategory(CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.lvtg)
	e1:SetOperation(s.lvop)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(s.etarget)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
end
function s.matfilter(c)
	return c:IsType(TYPE_TRAP+TYPE_SPELL)
end
function s.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetLeftScale()<10 end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
	local dc=Duel.TossDice(tp,1)
	e:SetLabel(dc)
end
function s.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function s.etarget(e,c)
	return (e:GetHandler():GetColumnGroup():IsContains(c) or c==e:GetHandler()) and c:IsSetCard(0xff1)
end
function s.efilter(e,te)
	if te:GetOwnerPlayer()==e:GetOwnerPlayer() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g:IsContains(e:GetHandler())
end
