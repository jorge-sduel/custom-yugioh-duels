--Sarah The K , Pirncess of Gust Vine
function c500311003.initial_effect(c)
c500311003.Is_Evolute=true
if not EVOLUTE_IMPORTED then Duel.LoadScript("proc_evolute.lua") end
	--c:EnableCounterPermit(0x88)
	c:EnableReviveLimit()
	Evolute.AddProcedure(c,nil,2,99,c500311003.rcheck)
	c:EnableReviveLimit()
		--cannot be target
	   --atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetValue(c500311003.atkval)
	c:RegisterEffect(e1)
   --pierce
 local e4=Effect.CreateEffect(c)
   e4:SetType(EFFECT_TYPE_SINGLE)
 e4:SetCode(EFFECT_PIERCE)
   c:RegisterEffect(e4)
	--Activate
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(500311003,0))
	--e7:SetCategory(CATEGORY_TODECK+CATEGORY_DAMAGE)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetRange(LOCATION_MZONE)
	--e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_TO_GRAVE)
	--e7:SetCountLimit(1,500311003)
	--e7:SetCondition(c500311003.descon)
	--e7:SetCost(c500311003.eqcost)
	e7:SetTarget(c500311003.destg)
	e7:SetOperation(c500311003.desop)
	c:RegisterEffect(e7)


end
function c500311003.rcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WIND)
end
function c500311003.atkval(e)
	return Duel.GetMatchingGroupCount(Card.IsAttribute,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,ATTRIBUTE_WIND)*100
end
function c500311003.filter1(c,ec,tp)
	return c:IsAttribute(ATTRIBUTE_WIND) or c:IsRace(RACE_PLANT)
end


function c500311003.cfilter(c)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetControler()==tp and c:IsReason(REASON_DESTROY) and c:IsReason(REASON_EFFECT)
end
function c500311003.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c500311003.cfilter,1,nil)
end
function c500311003.eqcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x111f,3,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x111f,3,REASON_COST)
end
function c500311003.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	if tc and tc:IsAbleToRemove() then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
		if tc:IsFaceup() and not tc:IsAttribute(ATTRIBUTE_DARK) then
			Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
		end
	end
end
function c500311003.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		if tc:IsLocation(LOCATION_REMOVED) and tc:IsType(TYPE_MONSTER) and not tc:IsAttribute(ATTRIBUTE_DARK) then
			Duel.Damage(1-tp,1000,REASON_EFFECT)
		end
	end
end
