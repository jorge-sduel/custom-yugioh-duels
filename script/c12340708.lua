--Morhai
function c12340708.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12340708,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,12340708)
	e1:SetCondition(c12340708.spcon)
	e1:SetCost(c12340708.spcost)
	e1:SetTarget(c12340708.sptg)
	e1:SetOperation(c12340708.spop)
	c:RegisterEffect(e1)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(c12340708.regop)
	c:RegisterEffect(e3)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12340708,2))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1)
	e4:SetCondition(c12340708.atkcon)
	e4:SetTarget(c12340708.atktg)
	e4:SetOperation(c12340708.atkop)
	c:RegisterEffect(e4)
end

function c12340708.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c12340708.mtfilter(c,tp)
	return c:IsSetCard(0x209) and c:IsAbleToGraveAsCost() and (c:IsLocation(LOCATION_HAND) or c:IsFaceup())
end
function c12340708.mtfilter2(c)
	return c:IsSetCard(0x209) and c:IsAbleToGraveAsCost() and c:IsFaceup() and c:GetSequence()<5
end
function c12340708.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g1=Duel.GetMatchingGroup(c12340708.mtfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
	local g2=Duel.GetMatchingGroup(c12340708.mtfilter2,tp,LOCATION_ONFIELD,0,e:GetHandler())
	if chk==0 then return g1:GetCount()>=2 and g2:GetCount()+ft>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local mg=nil
	if ft>0 then
		mg=g1:Select(tp,2,2,nil)
	elseif ft>-1 then
		mg=g2:Select(tp,1,1,nil)
		mg:Merge(g1:Select(tp,1,1,nil))
	else
		mg=g2:Select(tp,2,2,nil)
	end
	Duel.SendtoGrave(mg,REASON_COST)
end
function c12340708.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c12340708.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local tg=Duel.GetAttacker()
		if tg:IsOnField() then
			Duel.Destroy(tg,REASON_EFFECT)
		end
	end
end

function c12340708.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(12340708,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c12340708.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(12340708)>0
end
function c12340708.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x209)
end
function c12340708.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c12340708.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12340708.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c12340708.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c12340708.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end