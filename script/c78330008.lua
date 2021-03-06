--AB Stalker
function c78330008.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c78330008.spcon)
	e1:SetOperation(c78330008.spop)
	c:RegisterEffect(e1)
end
function c78330008.spfilter(c)
	return c:IsFaceup() and c:IsAbleToRemoveAsCost()
end
function c78330008.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c78330008.spfilter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c78330008.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c78330008.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST+REASON_TEMPORARY)
	g:GetFirst():RegisterFlagEffect(78330008,RESET_EVENT+0x1fe0000,0,0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(78330008,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_EVENT+0xff0000+RESET_PHASE+PHASE_STANDBY)
	e1:SetOperation(c78330008.retop)
	e1:SetLabelObject(g:GetFirst())
	c:RegisterEffect(e1)
end
function c78330008.retop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetFlagEffect(78330008)~=0 then
		Duel.ReturnToField(e:GetLabelObject())
	end
end
