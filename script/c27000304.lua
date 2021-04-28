---CCG: Familiar-Possessed Terrene Charmer - Aussa
function c27000304.initial_effect(c)
		c:EnableReviveLimit()
	--fusion material	
Fusion.AddProcMixN(c,true,true,c27000304.ffilter,2)
	--special summon condition
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_SPSUMMON_CONDITION)
		e1:SetValue(c27000304.SPLimit)
	c:RegisterEffect(e1)
	--special summon proc
	local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(27000304,3))
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_SPSUMMON_PROC)
		e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e2:SetRange(LOCATION_EXTRA)
		e2:SetCondition(c27000304.SPCon)
		e2:SetOperation(c27000304.SPOpe)
		e2:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(e2)
	--control
	local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(27000304,0))
		e3:SetCategory(CATEGORY_CONTROL)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e3:SetCode(EVENT_SPSUMMON_SUCCESS)
		e3:SetTarget(c27000304.CTRTarg)
		e3:SetOperation(c27000304.CTROpe)
	c:RegisterEffect(e3)
	--add to hand
	local e4=Effect.CreateEffect(c)
		e4:SetDescription(aux.Stringid(27000304,1))
		e4:SetCategory(CATEGORY_TOHAND)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
		e4:SetCode(EVENT_DESTROYED)
		e4:SetCondition(c27000304.THCon)
		e4:SetTarget(c27000304.THTarg)
		e4:SetOperation(c27000304.THOpe)
	c:RegisterEffect(e4)
	--cannot trigger
	local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetCode(EFFECT_CANNOT_TRIGGER)
		e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e5:SetRange(LOCATION_MZONE)
		e5:SetTargetRange(0,0xa)
		e5:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_TRAP))
	c:RegisterEffect(e5)
end
function c27000304.ffilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH)
end
-- {Special Summon Limit: Only from hand and Extra Deck}
function c27000304.SPLimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
-- {Special Summon Proc: Familiar-Possessed}
function c27000304.SPfilter1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xbf) and c:IsReleasable()
		and Duel.IsExistingMatchingCard(c27000304.SPfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c27000304.SPfilter2(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_EARTH) and c:IsReleasable()
end
function c27000304.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) 
		and sg:IsExists(c27000304.chk,1,nil,sg)
		and (not e:GetHandler():IsLocation(LOCATION_EXTRA) or Duel.GetLocationCountFromEx(tp,tp,sg,e:GetHandler())>0)
end
function c27000304.chk(c,sg)
	return c:IsSetCard(0xbf) 
		and sg:IsExists(Card.IsAttribute,1,c,ATTRIBUTE_EARTH)
end
function c27000304.SPCon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c27000304.SPfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
    and Duel.IsExistingMatchingCard(c27000304.SPfilter2,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c27000304.SPOpe(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c27000304.SPfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c27000304.SPfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	Duel.Release(g1,REASON_COST)
end 
-- {Monster Effect: Control}
function c27000304.CTRFilter1(c)
	return c:IsFaceup() 
		and c:IsControlerCanBeChanged() 
end
function c27000304.CTRTarg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c27000304.CTRFilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c27000304.CTRFilter1,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c27000304.CTRFilter1,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c27000304.TGFilter(c)
	return c:IsType(TYPE_MONSTER) 
		and c:IsAttribute(ATTRIBUTE_EARTH) 
		and c:IsAbleToGrave()
end
function c27000304.CTROpe(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsAttribute(ATTRIBUTE_EARTH) then
		if Duel.GetControl(tc,tp)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(tp,c27000304.TGFilter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoGrave(g,REASON_EFFECT)
			end
		end
	end
end
-- {Monster Effect: To Hand}
function c27000304.THCon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) 
		and c:IsPreviousLocation(LOCATION_MZONE) 
		and c:GetPreviousControler()==tp
end
function c27000304.THFilter(c)
	return c:IsType(TYPE_MONSTER) 
		and c:IsAttribute(ATTRIBUTE_EARTH) 
		and c:IsAbleToHand()
end
function c27000304.THTarg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c27000304.THFilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c27000304.THFilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c27000304.THFilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c27000304.THOpe(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end