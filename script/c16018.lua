--Paracyclissavior of Future, Starrain
local s,id=GetID()
function s.initial_effect(c)
	c:SetSPSummonOnce(id)
	--fusion summon
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,true,true,s.ffilter,3)
	Fusion.AddContactProc(c,s.contactfil,s.contactop,s.splimit,nil,nil,nil,false)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.thcon)
	e1:SetCost(s.thcost)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end
function s.ffilter(c,fc,sumtype,tp,sub,mg,sg)
	return c:IsRace(RACE_INSECT,fc,sumtype,tp) and c:IsLevelAbove(8) and (not sg or not sg:IsExists(s.fusfilter,1,c,c:GetCode(fc,sumtype,tp),fc,sumtype,tp))
end
function s.splimit(e,se,sp,st)
	return (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function s.contactfil(tp)
	return Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_MZONE,0,nil)
end
function s.contactop(g)
	Duel.SendtoGrave(g,REASON_COST+REASON_MATERIAL)
end
function s.fusfilter(c,code,fc,sumtype,tp)

	return c:IsSummonCode(fc,sumtype,tp,code) and not c:IsHasEffect(511002961)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_FUSION and c:IsPreviousLocation(LOCATION_EXTRA)
end
function s.cfilter(c)
	return c:IsRace(RACE_INSECT) and c:IsAbleToGraveAsCost()
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroup(tp,0,LOCATION_MZONE):FilterCount(Card.IsFaceup,nil)
	if chk==0 then return ct>0 and Duel.IsPlayerCanDiscardDeck(tp,ct) end
	e:SetLabel(Duel.DiscardDeck(tp,ct,REASON_COST))
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	if ct>#Duel.GetFieldGroup(tp,0,LOCATION_MZONE):Filter(Card.IsFaceup,nil) then return end
	local tg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local ng=tg:FilterSelect(tp,Card.IsFaceup,1,1,nil)
	Duel.ChangePosition(ng,POS_FACEDOWN_DEFENSE)
	local sg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE):Filter(Card.IsFacedown,nil)
	for tc in aux.Next(sg) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
		tc:RegisterEffect(e1)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
		e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e3:SetValue(1)
		tc:RegisterEffect(e3)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e1=e1:Clone()
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		tc:RegisterEffect(e1)
	end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE):Filter(Card.IsFaceup,nil)
	if #g>0 then Duel.BreakEffect() Duel.Destroy(g,REASON_EFFECT) end
end
