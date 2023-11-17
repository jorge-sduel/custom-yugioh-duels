--サイバー・ドラゴン・ズィーガー
--Cyber Dragon Sieger
--Scripted by ahtelel
local s,id=GetID()
function s.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsCode,CARD_CYBER_DRAGON),1,1)
	--Change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(CARD_CYBER_DRAGON)
	c:RegisterEffect(e1)
		--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsSummonCode,1,nil,lc,sumtype,tp,CARD_CYBER_DRAGON)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2100) end
	Duel.PayLPCost(tp,2100)
end
function s.filter(c,e,tp)
	return c:IsCode(CARD_CYBER_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
local ogatk=2100
	if #g>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK) 
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetLabel(ogatk)
	e2:SetLabelObject(g)
	e2:SetCondition(s.damcon)
	e2:SetOperation(s.damop)
	Duel.RegisterEffect(e2,tp)
end
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetFlagEffect(id)==0 then e:Reset() return false end
	return Duel.GetTurnPlayer()==tp
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(e:GetLabelObject():GetControler(),e:GetLabel(),REASON_EFFECT)
end

