--Evil HERO Wild Necromancer
function c888000009.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcCode2(c,86188410,45659520,true,true)
	--lizard check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(CARD_CLOCK_LIZARD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(c888000009.lizcon)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--Special Summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.EvilHeroLimit)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(888000009,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c888000009.condition)
	e2:SetTarget(c888000009.target)
	e2:SetOperation(c888000009.operation)
	c:RegisterEffect(e2)
end
c888000009.material_setcode={0x8,0x3008}
c888000009.dark_calling=true
c888000009.listed_names={CARD_DARK_FUSION,58932615,21844576}
function c888000009.lizcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),EFFECT_SUPREME_CASTLE)
end
function c888000009.condition(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c888000009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c888000009.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c888000009.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	local dg=Duel.Destroy(sg,REASON_EFFECT)
	if dg~=0 then
		Duel.BreakEffect()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>(dg-1) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c888000009.spfilter,tp,0,LOCATION_GRAVE,dg,dg,nil,e,tp)
			if g:GetCount()>0 then
				if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(EVENT_PHASE+PHASE_END)
					e1:SetCountLimit(1)
					e1:SetReset(RESET_PHASE+PHASE_END)
					e1:SetOperation(c888000009.desop)
					Duel.RegisterEffect(e1,tp)
					local e2=Effect.CreateEffect(e:GetHandler())
					e2:SetType(EFFECT_TYPE_FIELD)
					e2:SetRange(LOCATION_MZONE)
					e2:SetCode(EFFECT_CANNOT_SUMMON)
					e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e2:SetTargetRange(1,0)
					e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
					Duel.RegisterEffect(e2,tp)
					local e3=e2:Clone()
					e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
					Duel.RegisterEffect(e3,tp)
					local e4=e2:Clone()
					e4:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
					Duel.RegisterEffect(e4,tp)
				end
			end
		end
	end
end
function c888000009.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,0,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
