--Sin Truth Dragon
function c371155750.initial_effect(c)
	c:EnableReviveLimit()
	--Special Summon with "Sin Paradigm Shift"
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c371155750.paradigm)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(aux.FALSE)
	c:RegisterEffect(e2)
	--Malefic Truth Destruction
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(371155750,0))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetCondition(c371155750.destructioncon)
	e3:SetTarget(c371155750.destructiontg)
	e3:SetOperation(c371155750.destructionop)
	c:RegisterEffect(e3)
	--Malefic Protection
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetTarget(c371155750.sinprotectiontg)
	e4:SetOperation(c371155750.sinprotectionop)
	c:RegisterEffect(e4)
	--If "Malefic World" is not Face-Up on the Field, Destroy this Card
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_SELF_DESTROY)
	e5:SetCondition(c371155750.selfdestroycon)
	c:RegisterEffect(e5)
end
function c371155750.paradigm(e,se,sp,st)
	return st==(SUMMON_TYPE_SPECIAL+100000092)
end
function c371155750.destructioncon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local rc=tc:GetReasonCard()
	return eg:GetCount()==1 and rc:IsControler(tp) and rc:IsSetCard(0x23)
		and tc:IsType(TYPE_MONSTER) and tc:IsReason(REASON_BATTLE)
end
function c371155750.destructionfilter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c371155750.destructiontg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c371155750.destructionfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	if g:GetCount()~=0 then
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*800)
	end
end
function c371155750.destructionop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c371155750.destructionfilter,tp,0,LOCATION_MZONE,nil)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct~=0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,ct*800,REASON_EFFECT)
	end
end
function c371155750.sinfilter(c)
	return c:IsSetCard(0x23) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c371155750.sinprotectiontg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c371155750.sinfilter,tp,LOCATION_GRAVE,0,1,nil) end
	return Duel.SelectYesNo(tp,aux.Stringid(371155750,1))
end
function c371155750.sinprotectionop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c371155750.sinfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
end
function c371155750.selfdestroycon(e)
	return not Duel.IsEnvironment(27564031)
end