--Marine Majesty of Runic Waters
function c958625123.initial_effect(c)
	--Rune Summon
	c:EnableReviveLimit()
	aux.AddRuneProcedure(c,aux.NOT(aux.FilterBoolFunction(Card.IsType,TYPE_TOKEN)),1,1,c958625123.STMatFilter,1,1)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40884383,0))
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c958625123.tfcon)
	e1:SetTarget(c958625123.tftg)
	e1:SetOperation(c958625123.tfop)
	c:RegisterEffect(e1)
	--actlimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,1)
	e2:SetValue(c958625123.aclimit)
	e2:SetCondition(c958625123.accon)
	c:RegisterEffect(e2)
end
function c958625123.STMatFilter(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_FIELD)
end
function c958625123.tfcon(e,c)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RUNE
end
function c958625123.tffilter(c,tp)
	return c:IsType(TYPE_FIELD) and not c:IsForbidden()
end
function c958625123.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c958625123.tffilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c958625123.tfop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c958625123.tffilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		local fc2=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
		if fc2 and Duel.IsDuelType(DUEL_OBSOLETE_RULING) then
			Duel.Destroy(fc2,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c958625123.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c958625123.accon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
