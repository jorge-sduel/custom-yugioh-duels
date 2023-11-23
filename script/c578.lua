--
local s,id=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
	  --[[effect gain
	--special summon
	local e23=Effect.CreateEffect(c)
	e23:SetType(EFFECT_TYPE_FIELD)
	e23:SetCode(EFFECT_SPSUMMON_PROC)
	e23:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e23:SetRange(LOCATION_EXTRA)
	e23:SetCondition(Fusion.ContactCon(s.contactfil,nil))
	e23:SetTarget(Fusion.ContactTg(s.contactfil))
	e23:SetOperation(Fusion.ContactOp(s.contactop))
	e23:SetValue(SUMMON_TYPE_FUSION)
	local e24=Effect.CreateEffect(c)
	e24:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e24:SetRange(LOCATION_MZONE)
	e24:SetTargetRange(LOCATION_EXTRA,0)
	e24:SetTarget(s.eftg)
	e24:SetLabelObject(e23)
	c:RegisterEffect(e24)]]
end
function s.eftg(e,c)
	return c:IsHasEffect(id)
end
function s.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and	Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.filter2(c)
	return c:IsMonster()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
local g=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,c)
local lc=g:GetFirst()
		for lc in aux.Next(g) do
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetDescription(2)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(SUMMON_TYPE_FUSION)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetCondition(Fusion.ContactCon(s.contactfil,nil))
	e1:SetTarget(Fusion.ContactTg(s.contactfil))
	e1:SetOperation(Fusion.ContactOp(s.contactop))
	lc:RegisterEffect(e1)
	--[[local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_SINGLE)
	e14:SetRange(LOCATION_MZONE)
	e14:SetCode(id)
	e14:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	lc:RegisterEffect(e14)]]
		--to deck
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,2))
	e7:SetCategory(CATEGORY_TODECK)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e7:SetProperty(EFFECT_FLAG_REPEAT)
	e7:SetCountLimit(1)
	e7:SetRange(LOCATION_MZONE)
	e7:SetReset(RESET_PHASE+PHASE_END)
	e7:SetCondition(s.tdcon)
	e7:SetTarget(s.tdtg)
	e7:SetOperation(s.tdop)
	lc:RegisterEffect(e7)
	end
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_ONFIELD,0,nil)
end
function s.contactop(g,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST+REASON_MATERIAL)
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and c:IsAbleToDeck() then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	end
end

