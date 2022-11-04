--Chantress of the Runic Risen
function c946320791.initial_effect(c)
	--Rune Summon
	c:EnableReviveLimit()
	aux.AddRuneProcedure(c,aux.NOT(aux.FilterBoolFunction(Card.IsType,TYPE_TOKEN)),1,1,c946320791.STMatFilter,1,1)
	--Set Card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(961423423,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c946320791.setcon1)
	e1:SetTarget(c946320791.settg1)
	e1:SetOperation(c946320791.setop1)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65830223,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c946320791.cost)
	e2:SetCondition(c946320791.setcon2)
	e2:SetTarget(c946320791.settg2)
	e2:SetOperation(c946320791.setop2)
	c:RegisterEffect(e2)
end
function c946320791.STMatFilter(c)
	return (c:GetOriginalType()==0x2 or c:GetOriginalType()==0x4)
end
function c946320791.setcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_RUNE
end
function c946320791.mgfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c946320791.settg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=e:GetHandler():GetMaterial()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and mg:FilterCount(c946320791.mgfilter,nil)>0 end
end
function c946320791.setop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	if mg:FilterCount(c946320791.mgfilter,nil)>0 then
		local tc=mg:FilterSelect(c:GetControler(),c946320791.mgfilter,1,1,nil)
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c946320791.cfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c946320791.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c946320791.cfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c946320791.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c946320791.filter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsLocation(LOCATION_GRAVE) and c:GetControler()==1-tp and c:IsSSetable()
end
function c946320791.setcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c946320791.filter,1,nil,e:GetHandlerPlayer())
end
function c946320791.settg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(e:GetHandlerPlayer(),LOCATION_SZONE)>0 and eg:IsExists(c946320791.filter,1,nil,e:GetHandlerPlayer()) end
end
function c946320791.setop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(c:GetControler(),LOCATION_SZONE)<=0 then return end
	AI.Chat(eg:GetCount())
	local g=eg:Filter(c946320791.filter,nil,c:GetControler())
	AI.Chat(g:GetCount())
	if g:GetCount()>0 then
		local tc=g:Select(c:GetControler(),1,1,nil)
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end
