--
local s,id=GetID()
function s.initial_effect(c)
	--Ritual Summon
	local e1=Ritual.AddProcGreater({handler=c,filter=s.ritualfil,extrafil=s.extrafil,stage2=s.stage2,location=LOCATION_HAND|LOCATION_GRAVE,extratg=s.extratg})
	--todeck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1)
	e4:SetCost(s.atkcost)
	e4:SetCondition(s.descon)
	e4:SetTarget(s.tdtg)
	e4:SetOperation(s.tdop)
	c:RegisterEffect(e4)
end
s.listed_series={0x2093}
s.fit_monster={641} --should be removed in hardcode overhaul
s.listed_names={641}
function s.ritualfil(c)
	return c:IsSetCard(0x2093) and c:IsRitualMonster()
end
function s.mfilter(c)
	return not Duel.IsPlayerAffectedByEffect(c:GetControler(),69832741) and c:HasLevel() and (c:IsRace(RACE_WARRIOR) or c:IsRace(RACE_FAIRY)) and c:IsSetCard(0x93)
		and c:IsMonster() and c:IsAbleToRemove()
end
function s.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	return Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_GRAVE,0,nil)
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
function s.stage2(mat,e,tp,eg,ep,ev,re,r,rp,tc)
	tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,0))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(ATTRIBUTE_DARK)
	tc:RegisterEffect(e1)
end
function s.cfilter(c)
	return c:IsRitualMonster() and c:IsAbleToRemoveAsCost()
end
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.confilter(c)
	return c:IsCode(641)
end
function s.descon(e)
	return Duel.IsExistingMatchingCard(s.confilter,0,LOCATION_MZONE,0,1,nil)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoDeck(e:GetHandler(),nil,1,REASON_EFFECT)
Duel.Draw(tp,1,REASON_EFFECT)
	end
end
