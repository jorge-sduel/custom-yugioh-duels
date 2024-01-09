--シューティング・クェーサー・ドラゴン
--Shooting Quasar Dragon
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,s.tfilter,1,1,Synchro.NonTunerEx(Card.IsType,TYPE_SYNCHRO),1,99)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	--Negate the activation of an opponent's card or effect and banish it
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.negcon)
	e3:SetTarget(s.negtg)
	e3:SetOperation(s.negop)
	c:RegisterEffect(e3)
	--Special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCountLimit(1,id)
	--e4:SetCondition(s.spcon)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
	--material
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetCountLimit(1,{id,1})
	e5:SetCategory(CATEGORY_RECOVER)
	e5:SetTarget(s.destg)
	e5:SetOperation(s.desop)
	c:RegisterEffect(e5)
	--Unaffected by other monsters' effects and your opponent's activated Spell effects
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(s.adcon)
	e6:SetValue(s.immvalue)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(id,3))
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetCode(EVENT_RELEASE)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e7:SetCountLimit(1,id)
	--e7:SetCondition(s.spcon)
	e7:SetTarget(s.sptg)
	e7:SetOperation(s.spop)
	c:RegisterEffect(e7)
end
s.listed_names={37799519,CARD_STARDUST_DRAGON,id}
s.material={37799519}
s.material_setcode=0x1017
s.synchro_tuner_required=1
s.synchro_nt_required=2
function s.tfilter(c,lc,stype,tp)
	return  c:IsSummonCode(lc,stype,tp,37799519) or c:IsHasEffect(20932152)
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.IsChainNegatable(ev)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local relation=rc:IsRelateToEffect(re)
	if chk==0 then return (rc:IsAbleToRemove(tp) or not relation) end
	local rg=Group.FromCards(c)
	if relation then
		rg:AddCard(rc)
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--if c:IsRelateToEffect(e) then
		--Return during the End Phase
		if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
		--end
	end
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return (r&REASON_EFFECT)~=0
end
function s.spfilter(c,e,tp)
	return (not c:IsCode(id) and (c:IsCode(CARD_STARDUST_DRAGON) or c:ListsCode(CARD_STARDUST_DRAGON)) and (((c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_DECK) or c:IsLocation(LOCATION_GRAVE)) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0) or (c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)))
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE,0,nil,e,tp) 
	local tg=g:Select(tp,1,1,nil) 
	if tg then
		Duel.SpecialSummon(tg,0,tp,tp,true,true,POS_FACEUP)
	end
end
function s.synfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsFaceup()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.synfilter,tp,LOCATION_MZONE,0,1,nil,TYPE_SYNCHRO) end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_MZONE,0,nil,TYPE_SYNCHRO)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
 local g=Duel.GetMatchingGroup(s.synfilter,tp,LOCATION_MZONE,0,nil,TYPE_SYNCHRO)
	if #g>0 then
		local atk=Duel.GetFieldGroup(tp,LOCATION_MZONE,0):Filter(s.synfilter,nil):GetSum(Card.GetAttack)
		Duel.Recover(tp,atk,REASON_EFFECT)
	end
end
function s.adcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)>Duel.GetLP(1-tp)
end
function s.immvalue(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
