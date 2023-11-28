--
local s,id=GetID()
function s.initial_effect(c)
	--token
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.tktg)
	e1:SetOperation(s.tkop)
	c:RegisterEffect(e1)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
s.listed_names={75524093}
function s.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,75524093,0,TYPES_TOKEN,2500,2500,7,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP,tp) end
	local c=e:GetHandler()
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function s.tkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--if c:IsRelateToEffect(e) and c:IsFaceup() then
	--[[local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)]]
local rc=Duel.AnnounceRace(tp,1,RACE_ALL)
		--if not c:IsImmuneToEffect(e1) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			--and Duel.IsPlayerCanSpecialSummonMonster(tp,75524093,0,TYPES_TOKEN,2500,2500,7,RACE_FIEND,ATTRIBUTE_DARK,POS_FACEUP,tp) then
			local token=Duel.CreateToken(tp,75524093)
			Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	Token:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(rc)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	token:RegisterEffect(e2)
	--	end
	--end
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0x6008) or c:IsCode(75524093)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE)
end
function s.thfilter(c)
	return c:IsSetCard(0x6008) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
