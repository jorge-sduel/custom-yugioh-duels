--クリアー・ドラコナイト・オブ・カオス
function c30000008.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcCode2(c,30000018,30000019,true,true)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--remove att
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_REMOVE_ATTRIBUTE)
	e1:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c30000008.spcon)
	e2:SetTarget(c30000008.sptg)
	e2:SetOperation(c30000008.spop)
	c:RegisterEffect(e2)
	--banish
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c30000008.rmtg)
	e3:SetOperation(c30000008.rmop)
	c:RegisterEffect(e3)
end

--att count function
function c30000008.attfilter(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function c30000008.attcount(tp,loc1,loc2)
	local att=0
	if Duel.IsExistingMatchingCard(c30000008.attfilter,tp,loc1,loc2,1,nil,ATTRIBUTE_LIGHT) then att=att+1 end
	if Duel.IsExistingMatchingCard(c30000008.attfilter,tp,loc1,loc2,1,nil,ATTRIBUTE_DARK) then att=att+1 end
	if Duel.IsExistingMatchingCard(c30000008.attfilter,tp,loc1,loc2,1,nil,ATTRIBUTE_WATER) then att=att+1 end
	if Duel.IsExistingMatchingCard(c30000008.attfilter,tp,loc1,loc2,1,nil,ATTRIBUTE_FIRE) then att=att+1 end
	if Duel.IsExistingMatchingCard(c30000008.attfilter,tp,loc1,loc2,1,nil,ATTRIBUTE_EARTH) then att=att+1 end
	if Duel.IsExistingMatchingCard(c30000008.attfilter,tp,loc1,loc2,1,nil,ATTRIBUTE_WIND) then att=att+1 end
	if Duel.IsExistingMatchingCard(c30000008.attfilter,tp,loc1,loc2,1,nil,ATTRIBUTE_DEVINE) then att=att+1 end
	return att
end

function c30000008.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c30000008.spfilter(c,e,tp)
	return c:IsSetCard(0x306) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c30000008.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=c30000008.attcount(tp,0,LOCATION_MZONE)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and ct>0
		and Duel.IsExistingTarget(c30000008.spfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct>ft then ct=ft end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c30000008.spfilter,tp,LOCATION_REMOVED,0,1,ct,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c30000008.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sg=sg:Select(tp,ft,ft,nil)
	end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TRUE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function c30000008.rmfilter(c,tp)
	return c:IsFaceup() and c:IsAbleToRemove() and Duel.IsExistingMatchingCard(c30000008.sameatt,tp,0,LOCATION_GRAVE+LOCATION_EXTRA,1,nil,c:GetAttribute())
end
function c30000008.sameatt(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function c30000008.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(c30000008.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c30000008.rmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c30000008.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ct=Duel.GetMatchingGroupCount(c30000008.sameatt,tp,0,LOCATION_GRAVE+LOCATION_EXTRA,nil,tc:GetAttribute())
	if ct<1 then return end
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		tc:SetTurnCounter(0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,ct)
		e1:SetLabel(ct)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetCondition(c30000008.turncon)
		e1:SetOperation(c30000008.turnop)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e2:SetCondition(c30000008.retcon)
		e2:SetOperation(c30000008.retop)
		Duel.RegisterEffect(e2,tp)
		tc:RegisterFlagEffect(1082946,RESET_PHASE+PHASE_STANDBY,0,ct)
		local mt=_G["c"..tc:GetCode()]
		mt[tc]=e1
	end
end
function c30000008.turncon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffect(1082946)~=0
end
function c30000008.turnop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local ct=tc:GetTurnCounter()
	ct=ct+1
	tc:SetTurnCounter(ct)
	if ct>e:GetLabel() then
		tc:ResetFlagEffect(1082946)
		e:Reset()
	end
end
function c30000008.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local ct=tc:GetTurnCounter()
	if ct==e:GetLabel() then
		return true
	end
	if ct>e:GetLabel() then
		e:Reset()
	end
	return false
end
function c30000008.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ReturnToField(tc)
end