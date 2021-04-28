--Asura Reunion
function c12340910.initial_effect(c)
		c:EnableReviveLimit()
	--fusion material	
Fusion.AddProcFunRep(c,aux.FilterBoolFunction(Card.IsRace,RACE_DRAGON),3,true)
	--remove fusion type
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(0xee)
	e0:SetCode(EFFECT_REMOVE_TYPE)
	e0:SetValue(TYPE_FUSION)
	c:RegisterEffect(e0)
	--gain attributes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c12340910.matcheck)
	c:RegisterEffect(e1)
	--set attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c12340910.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e3)
	--attribute
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12340910,0))
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c12340910.target)
	e4:SetOperation(c12340910.operation)
	c:RegisterEffect(e4)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(12340910,1))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e5:SetCondition(c12340910.spcon)
	e5:SetTarget(c12340910.sptg)
	e5:SetOperation(c12340910.spop)
	c:RegisterEffect(e5)
end
function c12340910.matcheck(e,c)
	local g=c:GetMaterial()
	for i=0,10 do
		local t = math.pow(2, i)
		if g:IsExists(Card.IsAttribute,1,nil,t) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_ATTRIBUTE)
			e1:SetValue(t)
			e1:SetReset(RESET_EVENT+0xff0000)
			c:RegisterEffect(e1)
		end
	end
end

function c12340910.atkval(e,c)
	local g=Duel.GetMatchingGroup(Card.IsType,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	return g:GetClassCount(Card.GetAttribute)*1000
end

function c12340910.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,0)
	local aat=Duel.AnnounceAttribute(tp,1,0x7f)
	e:SetLabel(aat)
end
function c12340910.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetValue(c12340910.atkfilter)
	e1:SetLabel(e:GetLabel())
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c12340910.immfilter)
	e2:SetLabel(e:GetLabel())
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2,true)
end
function c12340910.atkfilter(e,c)
	return c:IsAttribute(e:GetLabel())
end
function c12340910.immfilter(e,te)
	return e:GetHandler()~=te:GetHandler() and te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsAttribute(e:GetLabel())
end

function c12340910.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetReasonPlayer()~=tp and c:IsReason(REASON_EFFECT) and c:IsPreviousPosition(POS_FACEUP)
		and c:GetPreviousControler()==c:GetOwner()
end
function c12340910.filter(c,e,tp,attr)
	return c:IsType(TYPE_MONSTER) and bit.band(c:GetAttribute(),attr)==c:GetAttribute() and c:GetAttribute()>0 and c:IsAbleToHand()
end
function c12340910.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local attr=e:GetHandler():GetPreviousAttributeOnField()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c12340910.filter(chkc,e,tp,attr) end
	if chk==0 then return Duel.IsExistingTarget(c12340910.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,attr) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c12340910.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,attr)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c12340910.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end