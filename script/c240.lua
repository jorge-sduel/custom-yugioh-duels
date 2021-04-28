--c23
function c240.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,9,3)
	c:EnableReviveLimit()
	--direct
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_HAND)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
	--battle indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(c240.indes)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_GRAVE)
	e4:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(7338,2))
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLE_DAMAGE)
	e5:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCost(c240.cost)
	e5:SetCondition(c240.con)
	e5:SetTarget(c240.destg)
	e5:SetOperation(c240.desop)
	c:RegisterEffect(e5,false,REGISTER_FLAG_DETACH_XMAT)
--
		local e6=Effect.CreateEffect(c)
		e6:SetType(EFFECT_TYPE_FIELD)
		e6:SetRange(LOCATION_MZONE)
		e6:SetTargetRange(0,LOCATION_HAND)
		e6:SetCode(EFFECT_DISABLE_EFFECT)
		c:RegisterEffect(e6)
		local e7=Effect.CreateEffect(c)
		e7:SetType(EFFECT_TYPE_FIELD)
		e7:SetRange(LOCATION_MZONE)
		e7:SetTargetRange(0,LOCATION_GRAVE)
		e7:SetCode(EFFECT_DISABLE_EFFECT)
		c:RegisterEffect(e7)
end
c240.xyz_number=23
function c240.indes(e,c)
	return not c:IsSetCard(0x48)
end
function c240.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c240.con(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetAttackTarget()==nil and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,66547759)
end
function c240.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_MZONE,1,nil,TYPE_MONSTER) end
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_MZONE,nil,TYPE_MONSTER)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c240.desop(e,tp,eg,ep,ev,re,r,rp)
 local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_MZONE,nil,TYPE_MONSTER)
	if Duel.Destroy(g,REASON_EFFECT)>0 then
		local dg=Duel.GetOperatedGroup()
		local atk=0
		local tc=dg:GetFirst()
		while tc do
			if tc:IsPreviousPosition(POS_FACEUP) then
				atk=atk+tc:GetPreviousAttackOnField()
			end
			tc=dg:GetNext()
		end
		Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
end
function c240.aclimit2(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE or re:GetActivateLocation()==LOCATION_HAND
end