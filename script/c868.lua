--Star-vader, Cold Death Dragon
function c868.initial_effect(c)
	--Lock
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(868,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c868.con)
	e1:SetOperation(c868.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c868.rmfilter(c)
	return c:IsFacedown()
end
function c868.con(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c868.rmfilter,c:GetControler(),0,LOCATION_REMOVED,1,nil)
end
function c868.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(1-tp,1)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		Duel.DisableShuffleCheck()
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
		local dis=Duel.SelectDisableField(tp,1,0,LOCATION_ONFIELD,0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_DISABLE_FIELD)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetLabel(dis)
		e1:SetLabelObject(tc)
		e1:SetCondition(c868.discon)
		e1:SetOperation(c868.disop)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetReset(RESET_PHASE+PHASE_END,2)
		e2:SetLabelObject(tc)
		e2:SetCountLimit(1)
		e2:SetCondition(c868.recon)
		e2:SetOperation(c868.retop)
		Duel.RegisterEffect(e2,tp)	
	end
end
function c868.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c868.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetLabelObject(),REASON_EFFECT)
end
function c868.discon(e,c)
	if e:GetLabelObject():IsLocation(LOCATION_REMOVED) then return true end
	return false
end
function c868.disop(e,tp)
	return e:GetLabel()
end