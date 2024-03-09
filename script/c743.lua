--
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,8,2,nil,nil,nil,nil,nil,s.xyzcheck)
	c:EnableReviveLimit()
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(s.matcheck)
	c:RegisterEffect(e1)
		--Special summon itself from GY
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--addown
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.condition)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
end
function s.xyzcheck(g)
	return g:IsExists(Card.IsType,1,nil,TYPE_FUSION) or g:IsExists(Card.IsType,1,nil,TYPE_XYZ) 
end
function s.matcheck(e,c)
	local ct=c:GetMaterial()
	if ct:IsExists(Card.IsType,1,nil,TYPE_FUSION) then
		--atk
	local ae=Effect.CreateEffect(c)
	ae:SetType(EFFECT_TYPE_IGNITION)
	ae:SetDescription(aux.Stringid(900787,0))
	ae:SetRange(LOCATION_MZONE)
	ae:SetCountLimit(1)
ae:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE-RESET_TOFIELD)
	ae:SetTarget(s.atktg)
	ae:SetOperation(s.atkop)
	c:RegisterEffect(ae)
	end
	if ct:IsExists(Card.IsType,1,nil,TYPE_XYZ) then
	--atk down
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(31833038,0))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
e3:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE-RESET_TOFIELD)
	e3:SetCost(s.cost)
	e3:SetOperation(s.activate)
	c:RegisterEffect(e3,false,REGISTER_FLAG_DETACH_XMAT)
	end
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
		local atk=0
		local tc=g:GetFirst()
		while tc do
			if tc:GetAttack()>0 then
				atk=atk+tc:GetAttack()
			end
			tc=g:GetNext()
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetControler()
	Duel.SetLP(1-tp,Duel.GetLP(1-p)/2,REASON_EFFECT)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(Duel.GetLP(1-p))
		e:GetHandler():RegisterEffect(e1)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetOverlayCount()==0
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	local rec=e:GetHandler():GetBaseAttack()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(rec)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	--if then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.BreakEffect()
	end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	e:SetLabelObject(tc)
	return tc and c:GetAttack()>=500 and c:GetDefense()>=500 and tc:IsFaceup() and (tc:GetAttack()>0 or tc:GetDefense()>0) and c:GetOverlayCount()==0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetLabelObject():CreateEffectRelation(e)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if c:IsRelateToEffect(e) and c:IsFaceup() and c:GetAttack()>=500 and c:GetDefense()>=500 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
		if tc:IsRelateToBattle() and tc:IsRelateToEffect(e) and tc:IsFaceup()
			and not c:IsHasEffect(EFFECT_REVERSE_UPDATE) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			e3:SetCode(EFFECT_UPDATE_ATTACK)
			e3:SetValue(-1500)
			tc:RegisterEffect(e3)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e4)
		end
	end
end

