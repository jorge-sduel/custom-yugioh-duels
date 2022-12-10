--Inzektor rango 6
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
	aux.AddEREquipLimit(c,nil,s.eqval,s.equipop,e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(s.eqcost)
	e2:SetTarget(s.eqtg2)
	e2:SetOperation(s.eqop2)
	c:RegisterEffect(e2,false,REGISTER_FLAG_DETACH_XMAT)
	aux.AddEREquipLimit(c,nil,function(ec,_,tp) return ec:IsControler(1-tp) end,s.equipop2,e2)
end
s.listed_series={0x56}
function s.eqval(ec,c,tp)
	return ec:IsControler(tp) and ec:IsSetCard(0x56)
end
function s.filter(c)
	return c:IsSetCard(0x56) and c:IsMonster() and not c:IsForbidden()
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function s.equipop(c,e,tp,tc)
	c:EquipByEffectAndLimitRegister(e,tp,tc,nil,true)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.filter),tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		s.equipop(c,e,tp,tc)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EVENT_ADJUST)
		e3:SetRange(0x7f)
		e3:SetOperation(s.op)
		tc:RegisterEffect(e3)
	end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eq=c:GetEquipTarget()
	local o=e:GetOwner()
	local code=c:GetOriginalCode()
	if eq==o and eq:IsFaceup() and eq:GetFlagEffect(code)==0 and not eq:IsDisabled() then
		local cid=eq:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
		eq:RegisterFlagEffect(code,RESET_EVENT+RESETS_STANDARD,0,1)
		e:SetLabel(cid)
	end 
	if not eq or o~=eq or eq:IsDisabled() then
		local cid=e:GetLabel()
		o:ResetEffect(cid,RESET_COPY)
	end
	if not eq or o~=eq then
		e:Reset()
	end
end
function s.eqfilter(c)
	return c:IsLocation(LOCATION_MZONE) or c:IsMonster() and not c:IsForbidden()
end
function s.eqtg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and s.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(s.eqfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,s.eqfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	if g:GetFirst():IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
	end
end
function s.equipop2(c,e,tp,tc)
	if not c:EquipByEffectAndLimitRegister(e,tp,tc) then return end
	if tc:IsFaceup() then
		local atk=tc:GetTextAttack()/2
		if atk<0 then atk=0 end
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetValue(atk)
		tc:RegisterEffect(e2)
		local def=tc:GetTextDefense()/2
		if def<0 then def=0 end
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_EQUIP)
		e3:SetCode(EFFECT_UPDATE_DEFENSE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetValue(def)
		tc:RegisterEffect(e3)
	end
end
function s.eqop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsMonster() then return end
	if not s.equipop(c,e,tp,tc) then return end
end
function s.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
