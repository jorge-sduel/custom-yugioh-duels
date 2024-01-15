--ドラゴン族・封印の壺
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Pos Change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_POSITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.target)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_HANDES)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetType(EFFECT_TYPE_QUICK_O)
 e4:SetCountLimit(1)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(s.condition)
	e4:SetTarget(s.destg)
	e4:SetOperation(s.desop)	
c:RegisterEffect(e4)
end
function s.target(e,c)
	return c:IsMonster()
end
function s.filter(c)
	return c:IsRace(RACE_FIEND) and re:IsSetCard(0x45) and c:IsFaceup()
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp,chk)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function s.tgfilter(c)
	return (c:IsSetCard(0x45) and c:IsMonster() and c:IsFaceup()) or c:IsLocation(LOCATION_HAND)
end
	--Activation legality
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	local dg=Duel.GetMatchingGroup(Card.IsMonster,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,tp,LOCATION_HAND+LOCATION_MZONE)
end
	--Destroy 1 monster from hand/field
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	if #g1>0 and Duel.Destroy(g1,REASON_EFFECT)~=0 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end