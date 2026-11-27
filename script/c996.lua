--ＴＨＥ トリッキー
--The Tricky
local s,id=GetID()
function s.initial_effect(c)
	--You can Special Summon this card (from your hand) by discarding 1 card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--atk change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(s.con)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(511001225)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,c)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and aux.SelectUnselectGroup(g,e,tp,1,1,nil,0)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,c)
	local sg=aux.SelectUnselectGroup(g,e,tp,1,1,nil,1,tp,HINTMSG_DISCARD,nil,nil,true)
	if sg and #sg>0 then
		e:SetLabelObject(sg)
		return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=e:GetLabelObject()
	if sg and #sg>0 then
		Duel.SendtoGrave(sg,REASON_DISCARD|REASON_COST)
	end
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_XYZ
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sync=c:GetReasonCard()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetOperation(s.rmop)
	e2:SetReset(RESETS_STANDARD_PHASE_END)
	sync:RegisterEffect(e2)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
