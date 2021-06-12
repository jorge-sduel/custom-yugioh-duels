--Armor
--Scripted by Secuter
local s,id=GetID()
if not ARMOR_IMPORTED then Duel.LoadScript("proc_armor.lua") end
s.armor_atk=500
s.armor_def=500
s.is_armor=true
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Armor
	aux.AddArmorProcedure(c,aux.FilterBoolFunction(Card.IsFaceup),nil,CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	local a1=Effect.CreateEffect(c)
	a1:SetType(EFFECT_TYPE_XMATERIAL)
	a1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	a1:SetCode(EFFECT_UPDATE_ATTACK)
	a1:SetCondition(aux.ArmorCondition)
	a1:SetValue(s.armor_value)
	c:RegisterEffect(a1)
	local a2=a1:Clone()
	a2:SetCode(EFFECT_UPDATE_DEFENSE)
	a2:SetValue(s.armor_value)
	c:RegisterEffect(a2)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--attach
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_ATTACH_ARMOR)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.attg)
	e2:SetOperation(s.atop)
	c:RegisterEffect(e2)
end
function s.armor_value(e,c)
	if e:GetHandler():GetFlagEffect(id)~=0 then
		return 1500
	else
		return s.armor_atk --500
	end
end

function s.spfilter(c,e,tp)
	return c.is_armor and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and e:GetHandler():IsRelateToEffect(re)
		and re:IsHasCategory(CATEGORY_ATTACH_ARMOR)
		--and e:GetHandler():GetFlagEffect(FLAG_ARMOR_RESOLVED)==1
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end

function s.attg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,e:GetHandler())
		and e:GetHandler():GetFlagEffect(c)==0 end
	e:GetHandler():RegisterFlagEffect(c,RESET_CHAIN,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARMOR)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_ATTACH_ARMOR,g,1,0,0)
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if c:GetOverlayCount()>0 then
			Duel.SendtoGrave(c:GetOverlayGroup(),REASON_RULE)
		end
		c:CancelToGrave()
		Auxiliary.AttachArmor(tc,c)
		tc:RegisterFlagEffect(id,RESET_EVENT+0x1fe0000,0,1)
	end
end