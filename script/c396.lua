--エクシーズ・チャージ・アップ
--Xyz Charge Up
local s,id=GetID()
function s.initial_effect(c)
	--Make effect damage become 0
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.spfilter1(c,e,tp)
	return c:IsSetCard(0x1115) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(s.damval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function s.damval(e,re,val,r,rp,rc)
	if (r&REASON_EFFECT)~=0 then return 0
	else return val end
end
