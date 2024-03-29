--Blade of the Osignis
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c,0,s.filter,s.eqlimit)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(66399653,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
end
function s.eqlimit(e,c)
	return c:GetControler()==e:GetHandler():GetControler()
		and (c:IsRace(RACE_PYRO) or c:IsSetCard(0xff6))
end
function s.filter(c)
	return c:IsRace(RACE_PYRO) or c:IsSetCard(0xff6)
end
function s.eqfilter(c,ec)
	return c:IsType(TYPE_UNION) and Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_MZONE,0,1,nil,c)
end
function s.filter2(c,eqc)
	return eqc:CheckUnionTarget(c) and aux.CheckUnionEquip(eqc,c)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_DECK) and chkc:IsControler(tp) and s.filter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>(e:GetHandler():IsLocation(LOCATION_SZONE) and 0 or 1)
		and Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,tp)
	--Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,s.filter2,tp,LOCATION_MZONE,0,1,1,nil,tc)
		local tc2=g:GetFirst()
		if tc2 and aux.CheckUnionEquip(tc,tc2) and Duel.Equip(tp,tc,tc2) then
			aux.SetUnionState(tc)
		end
	end
end
