--Odd-Eyes Sign Dragon 
c989512332.Is_Runic=true
if not RUNIC_IMPORTED then Duel.LoadScript("proc_runic.lua") end
function c989512332.initial_effect(c)
	--Rune Summon
	c:EnableReviveLimit()
 Runic.AddProcedure(c,c989512332.MonMatFilter,c989512332.MonMatFilter2,1,1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(989512332,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c989512332.target)
	e2:SetOperation(c989512332.operation)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(c989512332.condtion)
	e1:SetValue(1000)
	c:RegisterEffect(e1)
end
function c989512332.MonMatFilter(c)
	return c:GetLevel()==7 and c:IsRace(RACE_DRAGON)
end
function c989512332.MonMatFilter2(c)
	return c:IsType(TYPE_PENDULUM) and (c:IsLocation(LOCATION_PZONE) or c:IsLocation(LOCATION_SZONE))
end
function c989512332.filter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c989512332.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c989512332.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c989512332.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c989512332.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c989512332.condtion(e)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL)
		and Duel.GetAttacker()==e:GetHandler()
end
