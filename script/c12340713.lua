--Morhai Ignition
function c12340713.initial_effect(c)
	c:EnableReviveLimit()
	--ignition
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetCondition(c12340713.igncon)
	e1:SetOperation(c12340713.ignop)
	e1:SetValue(SUMMON_TYPE_SPECIAL)
	c:RegisterEffect(e1)
	--remove fusion type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(0xee)
	e2:SetCode(EFFECT_REMOVE_TYPE)
	e2:SetValue(TYPE_FUSION)
	c:RegisterEffect(e2)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340713,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,12340713)
	e2:SetCost(c12340713.descost)
	e2:SetTarget(c12340713.destg)
	e2:SetOperation(c12340713.desop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(c12340713.regop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12340713,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1,12340713)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(c12340713.thcon)
	e4:SetTarget(c12340713.thtg)
	e4:SetOperation(c12340713.thop)
	c:RegisterEffect(e4)
end
function c12340713.exfilter(c,sc,tp)
	return c:IsType(TYPE_MONSTER) and c:IsLevelAbove(7) and c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0
end
function c12340713.ignfilter(c)
	return c:IsType(TYPE_EFFECT)
end
function c12340713.igncon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c12340713.exfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,c,e:GetHandlerPlayer())
		and Duel.IsExistingMatchingCard(c12340713.ignfilter,e:GetHandlerPlayer(),LOCATION_HAND,0,1,nil)
end
function c12340713.ignop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c12340713.exfilter,tp,LOCATION_MZONE,0,1,1,nil,c,tp)
	if g:GetCount()>0 then
		local mg=Duel.SelectMatchingCard(tp,c12340713.ignfilter,tp,LOCATION_HAND,0,1,1,nil)
		if mg:GetCount()>0 then
			g:Merge(mg)
			Duel.SendtoGrave(g,REASON_MATERIAL)
			c:SetMaterial(g)
		end
	end
end

function c12340713.desfilter(c,ct)
	return c:IsFaceup() and c:IsType(ct)
end
function c12340713.cfilter(c,tp)
	local ct=0
	if c:IsType(TYPE_MONSTER) then ct=TYPE_MONSTER
	elseif c:IsType(TYPE_SPELL) then ct=TYPE_SPELL
	elseif c:IsType(TYPE_TRAP) then ct=TYPE_TRAP end
	return c:IsAbleToGraveAsCost() and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and ct>0
		and Duel.IsExistingMatchingCard(c12340713.desfilter,tp,0,LOCATION_ONFIELD,1,nil,ct)
end
function c12340713.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340713.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler(),e:GetHandlerPlayer()) end	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c12340713.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler(),e:GetHandlerPlayer())
	local ct=0
	if g:GetFirst():IsType(TYPE_MONSTER) then ct=TYPE_MONSTER
	elseif g:GetFirst():IsType(TYPE_SPELL) then ct=TYPE_SPELL
	elseif g:GetFirst():IsType(TYPE_TRAP) then ct=TYPE_TRAP end
	e:SetLabel(ct)
	Duel.SendtoGrave(g,REASON_COST)
end
function c12340713.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=e:GetLabel()
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c12340713.desfilter(chkc,ct) end
	if chk==0 then return Duel.IsExistingTarget(c12340713.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler(),e:GetHandlerPlayer()) end	
	--if chk==0 then return Duel.IsExistingTarget(c12340713.desfilter,tp,0,LOCATION_ONFIELD,1,nil,ct) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c12340713.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil,ct)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c12340713.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

function c12340713.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(12340713,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c12340713.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(12340713)>0
end
function c12340713.thfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAttackBelow(2400) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c12340713.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340713.thfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c12340713.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,c12340713.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end