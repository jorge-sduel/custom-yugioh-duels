--
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_DARK),8,2,nil,nil,nil,nil,nil,s.xyzcheck)
	c:EnableReviveLimit()
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(s.matcheck)
	c:RegisterEffect(e2)
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
	ae:SetCondition(s.atkcon)
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
local code=tc:GetOriginalCode()
			end
			tc=g:GetNext()
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
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
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(Duel.GetLP(1-p))
		tc:RegisterEffect(e1)
	end
end

