--レインボー・フラワー
function c153.initial_effect(c)
--link summon
	c:EnableReviveLimit()
	Link.AddProcedure(c,nil,2,8)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511000283,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetProperty(EFFECT_FLAG_REPEAT)
	e1:SetCountLimit(1)
	e1:SetOperation(c153.damop)
	c:RegisterEffect(e1)
	--register
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)	
	e2:SetOperation(c153.operation)
	c:RegisterEffect(e2)
	--gain atk
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(511000883)
	e3:SetTarget(c153.atktg)
	e3:SetOperation(c153.atkop)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(66523544,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c153.target)
	e4:SetOperation(c153.operation)
	c:RegisterEffect(e4)
end
function c153.damfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c153.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c153.damfilter,tp,0,LOCATION_GRAVE,nil)
	local dam=g:GetCount()*100
	Duel.Damage(1-tp,dam,REASON_EFFECT)
end
function c153.cfilter(c,tp)
	local val=0
	if c:GetFlagEffect(284)>0 then val=c:GetFlagEffectLabel(284) end
	return c:IsControler(tp) and c:GetAttack()~=val
end
function c153.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c153.cfilter,1,nil,tp)
end
function c153.diffilter1(c,g)
	local dif=0
	local val=0
	if c:GetFlagEffect(284)>0 then val=c:GetFlagEffectLabel(284) end
	if c:GetAttack()>val then dif=c:GetAttack()-val
	else dif=val-c:GetAttack() end
	return g:IsExists(c153.diffilter2,1,c,dif)
end
function c153.diffilter2(c,dif)
	local dif2=0
	local val=0
	if c:GetFlagEffect(284)>0 then val=c:GetFlagEffectLabel(284) end
	if c:GetAttack()>val then dif2=c:GetAttack()-val
	else dif2=val-c:GetAttack() end
	return dif~=dif2
end
function c153.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	local ec=eg:GetFirst()
	local g=eg:Filter(c153.diffilter1,nil,eg)
	local g2=Group.CreateGroup()
	if #g>0 then g2=g:Select(tp,1,1,nil) ec=g2:GetFirst() end
	if #g2>0 then Duel.HintSelection(g2) end
	local dam=0
	local val=0
	if ec:GetFlagEffect(284)>0 then val=ec:GetFlagEffectLabel(284) end
	if ec:GetAttack()>val then dam=ec:GetAttack()-val
	else dam=val-ec:GetAttack() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetTargetParam(dam)
end
function c153.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local atk=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(atk)
		tc:RegisterEffect(e1)
	end
end

function c153.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c153.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c153.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c153.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetChainLimit(c153.climit)
end
function c153.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c153.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function c153.climit(e,lp,tp)
	return lp==tp or not e:IsHasType(EFFECT_TYPE_ACTIVATE)
end
