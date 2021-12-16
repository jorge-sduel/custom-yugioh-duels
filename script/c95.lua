--divine mistres Gravitania
function c95.initial_effect(c)
	--hancur
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e9:SetTarget(c95.atktg)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EFFECT_CANNOT_MSET)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	c:RegisterEffect(e10)
	local e11=e9:Clone()
	e11:SetCode(EFFECT_CANNOT_TURN_SET)
	e11:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	c:RegisterEffect(e11)
	local e12=e9:Clone()
	e12:SetCode(EFFECT_LIGHT_OF_INTERVENTION)
	e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	c:RegisterEffect(e12)
	--summon with 1 tribute
	local e1=Effect.CreateEffect(c)
e1:SetDescription(aux.Stringid(12340417,13))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c95.otcon1)
	e1:SetOperation(c95.otop1)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	--summon with 2 tribute
	local e2=Effect.CreateEffect(c)
e2:SetDescription(aux.Stringid(12340417,14))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetCondition(c95.otcon2)
	e2:SetOperation(c95.otop2)
	e2:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e2)
	--summon with 3 tribute
	local e3=Effect.CreateEffect(c)
e3:SetDescription(aux.Stringid(12340417,15))	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SUMMON_PROC)
	e3:SetCondition(c95.otcon3)
	e3:SetOperation(c95.otop3)
	e3:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e3)
	--summon with 4 tribute
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12340002,3))
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SUMMON_PROC)
	e4:SetCondition(c95.otcon4)
	e4:SetOperation(c95.otop4)
	e4:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e4)
	--summon with 5 tribute
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(12340002,4))
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SUMMON_PROC)
	e5:SetCondition(c95.otcon5)
	e5:SetOperation(c95.otop5)
	e5:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e5)
end
function c95.otcon1(e,c)

	if c==nil then return true end

	local g=Duel.GetTributeGroup(c)

	return Duel.GetTributeCount(c)>=1 and g:IsExists(Card.IsFaceup,1,nil)

end

function c95.otop1(e,tp,eg,ep,ev,re,r,rp,c)

	local g=Duel.GetTributeGroup(c)

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)

	local sg=g:FilterSelect(tp,Card.IsFaceup,1,1,nil)

	c:SetMaterial(sg)

	Duel.Release(sg, REASON_SUMMON+REASON_MATERIAL)

	--direct attack

	local e1=Effect.CreateEffect(c)

	e1:SetType(EFFECT_TYPE_SINGLE)

	e1:SetCode(EFFECT_DIRECT_ATTACK)

	c:RegisterEffect(e1)

end

function c95.otcon2(e,c)

	if c==nil then return true end

	local g=Duel.GetTributeGroup(c)

	return Duel.GetTributeCount(c)>=2 and g:IsExists(Card.IsFaceup,2,nil)

end

function c95.otop2(e,tp,eg,ep,ev,re,r,rp,c)

	local g=Duel.GetTributeGroup(c)

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)

	local sg=g:FilterSelect(tp,Card.IsFaceup,2,2,nil)

	c:SetMaterial(sg)

	Duel.Release(sg, REASON_SUMMON+REASON_MATERIAL)

	--atkup

	local e2=Effect.CreateEffect(c)

	e2:SetType(EFFECT_TYPE_SINGLE)

	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)

	e2:SetRange(LOCATION_MZONE)

	e2:SetCode(EFFECT_SET_ATTACK_FINAL)

	e2:SetValue(c95.atkval)

	c:RegisterEffect(e2)

end

function c95.atkval(e,c)

	return c:GetAttack()*2

end

function c95.otcon3(e,c)

	if c==nil then return true end

	local g=Duel.GetTributeGroup(c)

	return Duel.GetTributeCount(c)>=3 and g:IsExists(Card.IsFaceup,3,nil)

end

function c95.otop3(e,tp,eg,ep,ev,re,r,rp,c)

	if chk==0 then return Duel.IsPlayerCanDraw(tp,3) end

	local g=Duel.GetTributeGroup(c)

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)

	local sg=g:FilterSelect(tp,Card.IsFaceup,3,3,nil)

	c:SetMaterial(sg)

	Duel.Release(sg, REASON_SUMMON+REASON_MATERIAL)

	--draw

	local e3=Effect.CreateEffect(c)

	e3:SetCategory(CATEGORY_DRAW)

	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)

	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)

	e3:SetCode(EVENT_SUMMON_SUCCESS)

	e3:SetCondition(c95.descon)

	e3:SetTarget(c95.target)

	e3:SetOperation(c95.activate)

	c:RegisterEffect(e3)

end

function c95.target(e,tp,eg,ep,ev,re,r,rp,chk)

	if chk==0 then return Duel.IsPlayerCanDraw(tp,3) end

	Duel.SetTargetPlayer(tp)

	Duel.SetTargetParam(3)

	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)

end

function c95.activate(e,tp,eg,ep,ev,re,r,rp)

	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)

	Duel.Draw(p,d,REASON_EFFECT)

end

function c95.descon(e,tp,eg,ep,ev,re,r,rp)

	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE

end

function c95.otcon4(e,c)

	if c==nil then return true end

	local g=Duel.GetTributeGroup(c)

	return Duel.GetTributeCount(c)>=4 and g:IsExists(Card.IsFaceup,4,nil)

end

function c95.otop4(e,tp,eg,ep,ev,re,r,rp,c)

	local g=Duel.GetTributeGroup(c)

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)

	local sg=g:FilterSelect(tp,Card.IsFaceup,4,4,nil)

	c:SetMaterial(sg)

	Duel.Release(sg, REASON_SUMMON+REASON_MATERIAL)

	--shuffle

	local e4=Effect.CreateEffect(c)

	e4:SetCategory(CATEGORY_TODECK)

	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)

	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)

	e4:SetCode(EVENT_SUMMON_SUCCESS)

	e4:SetCondition(c95.descon4)

	e4:SetTarget(c95.target4)

	e4:SetOperation(c95.activate4)

	c:RegisterEffect(e4)

end

function c95.descon4(e,tp,eg,ep,ev,re,r,rp)

	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE

end

function c95.target4(e,tp,eg,ep,ev,re,r,rp,chk)

	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND+LOCATION_ONFIELD)>0 end

end

function c95.activate4(e,tp,eg,ep,ev,re,r,rp)

	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND+LOCATION_ONFIELD)

	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)

end

function c95.otcon5(e,c)

	if c==nil then return true end

	local g=Duel.GetTributeGroup(c)

	return Duel.GetTributeCount(c)>=5 and g:IsExists(Card.IsFaceup,5,nil)

end

function c95.otop5(e,tp,eg,ep,ev,re,r,rp,c)

	local g=Duel.GetTributeGroup(c)

	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)

	local sg=g:FilterSelect(tp,Card.IsFaceup,5,5,nil)

	c:SetMaterial(sg)

	Duel.Release(sg, REASON_SUMMON+REASON_MATERIAL)

	--atkup

	local e5=Effect.CreateEffect(c)

	e5:SetType(EFFECT_TYPE_SINGLE)

	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)

	e5:SetRange(LOCATION_MZONE)

	e5:SetCode(EFFECT_SET_ATTACK_FINAL)

	e5:SetValue(c95.atkval)

	c:RegisterEffect(e5)

	--direct attack

	local e6=Effect.CreateEffect(c)

	e6:SetType(EFFECT_TYPE_SINGLE)

	e6:SetCode(EFFECT_DIRECT_ATTACK)

	c:RegisterEffect(e6)

	--draw

	local e7=Effect.CreateEffect(c)

	e7:SetCategory(CATEGORY_DRAW)

	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)

	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)

	e7:SetCode(EVENT_SUMMON_SUCCESS)

	e7:SetCondition(c95.descon)

	e7:SetTarget(c95.target)

	e7:SetOperation(c95.activate)

	c:RegisterEffect(e7)

	--shuffle

	local e8=Effect.CreateEffect(c)

	e8:SetCategory(CATEGORY_TODECK)

	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)

	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)

	e8:SetCode(EVENT_SUMMON_SUCCESS)

	e8:SetCondition(c95.descon4)

	e8:SetTarget(c95.target4)

	e8:SetOperation(c95.activate4)

	c:RegisterEffect(e8)

end

function c95.atktg(e,c)

	return c~=e:GetHandler()

end
