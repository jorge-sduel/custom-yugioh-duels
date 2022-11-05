--Mastered Sun of Runic Flames
function c943689072.initial_effect(c)
	--Rune Summon
	c:EnableReviveLimit()
	aux.AddRuneProcedure(c,aux.NOT(aux.FilterBoolFunction(Card.IsType,TYPE_TOKEN)),1,1,c943689072.STMatFilter,1,1)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40884383,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c943689072.eqcon1)
	e1:SetTarget(c943689072.eqtg1)
	e1:SetOperation(c943689072.eqop1)
	c:RegisterEffect(e1)
	--equip change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(68084557,1))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c943689072.eqtg2)
	e2:SetOperation(c943689072.eqop2)
	c:RegisterEffect(e2)
end
function c943689072.STMatFilter(c)
	return c:IsType(TYPE_EQUIP) and c:IsType(TYPE_SPELL)
end
function c943689072.eqcon1(e,c)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RUNE
end
function c943689072.tcfilter(c,tp)
	return c:IsFaceup()
		and Duel.IsExistingMatchingCard(c943689072.eqfilter,tp,LOCATION_DECK,0,1,nil,c,tp)
end
function c943689072.eqfilter(c,tc,tp)
	return c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(tc) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c943689072.eqtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c943689072.tcfilter(chkc,tp) end
	local ft=0
	if e:GetHandler():IsLocation(LOCATION_HAND) then ft=1 end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>ft
		and Duel.IsExistingTarget(c943689072.tcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c943689072.tcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
end
function c943689072.eqop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,c943689072.eqfilter,tp,LOCATION_DECK,0,1,1,nil,tc,tp)
		if g:GetCount()>0 then
			local ec=g:GetFirst()
			Duel.Equip(tp,ec,tc)
			--negate effects
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			ec:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			ec:RegisterEffect(e2)
		end
	end
end
function c943689072.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_EQUIP) and Duel.IsExistingMatchingCard(Card.IsFaceup,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,1,c:GetEquipTarget())
end
function c943689072.eqtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c943689072.filter2(chkc,e:GetHandler()) end
	if chk==0 then return Duel.IsExistingTarget(c943689072.filter2,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c943689072.filter2,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c943689072.eqop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and c:IsFaceup() and c:IsRelateToEffect(e) then
		local tg=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,tc:GetEquipTarget())
		Duel.Equip(tp,tc,tg:GetFirst())
		--Add New Equip Limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetLabelObject(tg:GetFirst())
		e1:SetValue(c943689072.eqlimit)
		tc:RegisterEffect(e1)
	end
end
function c943689072.eqlimit(e,c)
	return e:GetLabelObject()==c
end
