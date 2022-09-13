--Verdant Mutant
c960123542.IsIgnition=true
if not IGNITION_IMPORTED then Duel.LoadScript("proc_ignition.lua") end
function c960123542.initial_effect(c)
	--ignition summon
	Ignition.AddProcedure(c,c960123542.filter2,c960123542.filter1,1,99)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(960123542,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c960123542.cost)
	e1:SetTarget(c960123542.target)
	e1:SetOperation(c960123542.operation)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_INSECT))
	c:RegisterEffect(e2)
end
function c960123542.filter1(c)
	return c:IsType(TYPE_SPELL)
end
function c960123542.filter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_INSECT)
end
function c960123542.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 and Duel.CheckReleaseGroup(tp,nil,1,nil) end
	local sg=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
	Duel.Release(sg,REASON_COST)
end
function c960123542.filter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c960123542.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c960123542.filter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c960123542.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c960123542.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
