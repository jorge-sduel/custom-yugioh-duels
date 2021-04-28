--Asura
function c12340906.initial_effect(c)
	c:SetUniqueOnField(1,0,c:GetOriginalCode())
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12340906,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c12340906.ntcon)
	c:RegisterEffect(e1)
	--des
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340906,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c12340906.con)
	e2:SetTarget(c12340906.tg)
	e2:SetOperation(c12340906.op)
	c:RegisterEffect(e2)
end
function c12340906.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:GetLevel()>4
		and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end

function c12340906.filter(c,attr)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAttribute(attr)
end
function c12340906.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not Duel.IsExistingMatchingCard(c12340908.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,c:GetOriginalAttribute())
end
function c12340906.thfilter(c)
	return c:IsSetCard(0x281) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c12340906.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local res=Duel.IsExistingMatchingCard(c12340906.thfilter,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340906.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c12340906.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c12340906.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end