--Armor
--Scripted by Secuter
local s,id=GetID()
if not ARMOR_IMPORTED then Duel.LoadScript("proc_armor.lua") end
s.armor_atk=300
s.armor_def=300
s.is_armor=true
function s.initial_effect(c)
	--Armor
	aux.AddArmorProcedure(c,aux.FilterBoolFunction(Card.IsFaceup),nil,CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	local a1=Effect.CreateEffect(c)
	a1:SetType(EFFECT_TYPE_XMATERIAL)
	a1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	a1:SetCode(EFFECT_UPDATE_ATTACK)
	a1:SetCondition(aux.ArmorCondition)
	a1:SetValue(s.armor_atk)
	c:RegisterEffect(a1)
	local a2=a1:Clone()
	a2:SetCode(EFFECT_UPDATE_DEFENSE)
	a2:SetValue(s.armor_def)
	c:RegisterEffect(a2)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

function s.cfilter(c)
	return c:GetOverlayCount()>=2 and not c:IsType(TYPE_XYZ)
		and c:CheckRemoveOverlayCard(tp,2,REASON_COST)
end
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.cfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	g:GetFirst():RemoveOverlayCard(tp,2,2,REASON_COST)
end

function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and e:GetHandler():IsRelateToEffect(re)
		and re:IsHasCategory(CATEGORY_ATTACH_ARMOR)
		--and e:GetHandler():GetFlagEffect(FLAG_ARMOR_RESOLVED)==1
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end