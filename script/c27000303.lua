---CCG: Familiar-Possessed Tempest Charmer - Wynn
function c27000303.initial_effect(c)
	--synchro summon
Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--special summon proc
	local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(27000302,3))
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_SPSUMMON_PROC)
		e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e2:SetRange(LOCATION_EXTRA)
		e2:SetCondition(c27000303.SPCon)
		e2:SetOperation(c27000303.SPOpe)
		e2:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e2)
	--control
	local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(27000303,0))
		e3:SetCategory(CATEGORY_CONTROL)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e3:SetCode(EVENT_SPSUMMON_SUCCESS)
		e3:SetTarget(c27000303.CTRTarg)
		e3:SetOperation(c27000303.CTROpe)
	c:RegisterEffect(e3)
	--add to hand
	local e4=Effect.CreateEffect(c)
		e4:SetDescription(aux.Stringid(27000303,1))
		e4:SetCategory(CATEGORY_TOHAND)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
		e4:SetCode(EVENT_DESTROYED)
		e4:SetCondition(c27000303.THCon)
		e4:SetTarget(c27000303.THTarg)
		e4:SetOperation(c27000303.THOpe)
	c:RegisterEffect(e4)
	--cannot target
	local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
		e5:SetRange(LOCATION_MZONE)
		e5:SetTargetRange(LOCATION_MZONE,0)
		e5:SetTarget(c27000303.TGLimit)
		e5:SetValue(aux.tgoval)
	c:RegisterEffect(e5)
end
-- {Special Summon Limit: Only from hand and Extra Deck}
function c27000303.SPLimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
-- {Special Summon Proc: Familiar-Possessed}
function c27000303.SPfilter1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xbf) and c:IsReleasable()
		and Duel.IsExistingMatchingCard(c27000303.SPfilter2,tp,LOCATION_MZONE,0,1,c)
end
function c27000303.SPfilter2(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND) and c:IsReleasable()
end
function c27000303.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) 
		and sg:IsExists(c27000303.chk,1,nil,sg)
		and (not e:GetHandler():IsLocation(LOCATION_EXTRA) or Duel.GetLocationCountFromEx(tp,tp,sg,e:GetHandler())>0)
end
function c27000303.chk(c,sg)
	return c:IsSetCard(0xbf) 
		and sg:IsExists(Card.IsAttribute,1,c,ATTRIBUTE_WIND)
end
function c27000303.SPCon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c27000303.SPfilter1,tp,LOCATION_MZONE,0,1,nil,tp)
    and Duel.IsExistingMatchingCard(c27000303.SPfilter2,tp,LOCATION_MZONE,0,1,nil,tp)
end
function c27000303.SPOpe(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c27000303.SPfilter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c27000303.SPfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst())
	g1:Merge(g2)
	Duel.Release(g1,REASON_COST)
end 
-- {Monster Effect: Control}
function c27000303.CTRFilter1(c)
	return c:IsFaceup() 
		and c:IsControlerCanBeChanged() 
end
function c27000303.CTRTarg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c27000303.CTRFilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c27000303.CTRFilter1,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c27000303.CTRFilter1,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c27000303.TGFilter(c)
	return c:IsType(TYPE_MONSTER) 
		and c:IsAttribute(ATTRIBUTE_WIND) 
		and c:IsAbleToGrave()
end
function c27000303.CTROpe(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsAttribute(ATTRIBUTE_WIND) then
		if Duel.GetControl(tc,tp)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(tp,c27000303.TGFilter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoGrave(g,REASON_EFFECT)
			end
		end
	end
end
-- {Monster Effect: To Hand}
function c27000303.THCon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) 
		and c:IsPreviousLocation(LOCATION_MZONE) 
		and c:GetPreviousControler()==tp
end
function c27000303.THFilter(c)
	return c:IsType(TYPE_MONSTER) 
		and c:IsAttribute(ATTRIBUTE_WIND) 
		and c:IsAbleToHand()
end
function c27000303.THTarg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c27000303.THFilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c27000303.THFilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c27000303.THFilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c27000303.THOpe(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
-- {Monster Effect: Cannot target}
function c27000303.TGLimit(e,c)
	return c~=e:GetHandler()
end