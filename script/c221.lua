--xyzsin spmking
function c221.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_DARK),8,2)
	c:EnableReviveLimit()
	--ATK Up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c221.con2)
	e1:SetValue(c221.atkval)
	c:RegisterEffect(e1)
	--copy	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)	
	e2:SetCondition(c221.con)
	e2:SetOperation(c221.operation)
	c:RegisterEffect(e2)
	--attach
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100412008,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(aux.bdocon)
	e3:SetTarget(c221.atchtg)
	e3:SetOperation(c221.atchop)
	c:RegisterEffect(e3)
	--Special summon
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(4796100,0))
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetTarget(c221.sptg)
	e7:SetOperation(c221.spop)
	c:RegisterEffect(e7)
	--material
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetRange(LOCATION_GRAVE)
	e8:SetCost(aux.bfgcost)
	e8:SetTarget(c221.mattg)
	e8:SetOperation(c221.matop)
	c:RegisterEffect(e8)
end
function c221.atkval(e,c)
	return c:GetOverlayCount()*400
end
function c221.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_FUSION)
end
function c221.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetHandler():GetOverlayGroup():IsExists(Card.IsType,1,nil,TYPE_XYZ)
end
function c221.filter(c)
	return c:IsType(TYPE_MONSTER)
end
function c221.operation(e,c)
	local c=e:GetHandler()
	local og=c:GetOverlayGroup()
	local wg=og:Filter(c221.filter,nil)
	local wbc=wg:GetFirst()
	while wbc do
		local code=wbc:GetOriginalCode()
		if c:GetFlagEffect(code)==0 then
			c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
			c:RegisterFlagEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		end
		wbc=wg:GetNext()
	end
end
function c221.atchtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)	
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) end
	local bc=e:GetHandler():GetBattleTarget()
	Duel.SetTargetCard(bc)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,bc,1,0,0)
end
function c221.atchop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc and tc:IsRelateToEffect(e) and not tc:IsLocation(LOCATION_DECK) then
		local og=tc:GetOverlayGroup()
		if #og>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function c221.spfilter(c,e,tp)
	return (c:IsType(TYPE_XYZ) or c:IsType(TYPE_FUSION)) and not c:IsCode(221) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c221.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c221.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c221.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c221.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c221.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c221.xyzfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c221.matfilter(c)
	return c:IsType(TYPE_MONSTER) and (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA)) and c:IsCanOverlay()
end
function c221.mattg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c221.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c221.xyzfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c221.matfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c221.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c221.matop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c221.matfilter),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,2,2,nil)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end
