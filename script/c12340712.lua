--Morhai Ignition
function c12340712.initial_effect(c)
	c:EnableReviveLimit()
	--ignition
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCondition(c12340712.igncon)
	e1:SetOperation(c12340712.ignop)
	e1:SetValue(SUMMON_TYPE_SPECIAL)
	c:RegisterEffect(e1)
	--remove fusion type
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetRange(0xee)
	e0:SetCode(EFFECT_REMOVE_TYPE)
	e0:SetValue(TYPE_FUSION)
	c:RegisterEffect(e0)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(c12340712.indct)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12340712,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,12340712)
	e3:SetCost(c12340712.cost)
	e3:SetTarget(c12340712.tg)
	e3:SetOperation(c12340712.op)
	c:RegisterEffect(e3)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetOperation(c12340712.regop)
	c:RegisterEffect(e5)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12340712,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1,12340712)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c12340712.thcon)
	e4:SetTarget(c12340712.thtg)
	e4:SetOperation(c12340712.thop)
	c:RegisterEffect(e4)
end
function c12340712.exfilter(c,sc,tp)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
end
function c12340712.ignfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLevelAbove(7)
end
function c12340712.igncon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c12340712.exfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,c,e:GetHandlerPlayer())
		and Duel.IsExistingMatchingCard(c12340712.ignfilter,e:GetHandlerPlayer(),LOCATION_HAND,0,1,nil)
end
function c12340712.ignop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c12340712.exfilter,tp,LOCATION_MZONE,0,1,1,nil,c,tp)
	if g:GetCount()>0 then
		local mg=Duel.SelectMatchingCard(tp,c12340712.ignfilter,tp,LOCATION_HAND,0,1,1,nil)
		if mg:GetCount()>0 then
			g:Merge(mg)
			Duel.SendtoGrave(g,REASON_MATERIAL)
			c:SetMaterial(g)
		end
	end
end

function c12340712.indtg(e,c)
	return c:IsType(TYPE_MONSTER) and c~=e:GetHandler()
end
function c12340712.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE)~=0 then
		return 1
	else return 0 end
end

function c12340712.mtfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost() and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function c12340712.filter(c,e,sp)
	return c:IsLevelBelow(3) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c12340712.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340712.mtfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c12340712.mtfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c12340712.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340712.filter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c12340712.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c12340712.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c12340712.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(12340712,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c12340712.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(12340712)>0
end
function c12340712.thfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsLevelAbove(7) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c12340712.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340712.thfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c12340712.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c12340712.thfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end