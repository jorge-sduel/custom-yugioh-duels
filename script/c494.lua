--F.A Neutrino
local s,id=GetID()
s.Is_Neutrino=true
function s.initial_effect(c)
	--Fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,467,s.matfilter)
--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(s.eqcon)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
	aux.AddEREquipLimit(c,nil,s.eqval,aux.EquipByEffectAndLimitRegister,e1)
	--Special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_LEAVE_FIELD)
	--e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
		--[[local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EVENT_ADJUST)
		e3:SetRange(LOCATION_MZONE)
		e3:SetOperation(s.op)
		c:RegisterEffect(e3)]]
end
s.listed_names={467}
function s.matfilter(c)
	return c.Is_Neutrino
end
function s.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function s.filter(c)
	return c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_DECK) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,ft,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,#g,0,0)
end
function s.equipop(c,e,tp,tc,chk)
--local ht=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local eff=false or chk
	Duel.Equip(tp,tc,c,false,eff)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(1)
	e1:SetLabelObject(e:GetLabelObject())
	tc:RegisterEffect(e1)
	--if ht<6 then 
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetTargetCards(e)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<#sg then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	for tc in aux.Next(sg) do
		Card.EquipByEffectAndLimitRegister(c,e,tp,tc)
	--	Duel.Draw(tp,6,REASON_EFFECT)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetCode(EVENT_ADJUST)
		e3:SetRange(0x7f)
		e3:SetOperation(s.op)
		tc:RegisterEffect(e3)
	end
end
function s.eqval(ec,c,tp)
	return ec:IsControler(tp) and ec:IsType(TYPE_EQUIP)
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
function s.spfilter(c,e,tp)
	return ((c:IsCode(467) or c:IsCode(493) or c:IsCode(12632096) or c:IsCode(68396121) or c:IsCode(39272762) or c:IsCode(48348921) or c:IsCode(1497) or c:IsCode(249001043)) or c:IsHasEffect(555)) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		g:SetStatus(STATUS_PROC_COMPLETE,true)
	end
end
