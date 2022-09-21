--Prism Beast Opal Grypho
local s,id=GetID()
function s.initial_effect(c)
	--link summon
		Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x1034),2,2,s.lcheck)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21698716,1))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40854197,0))
	e2:SetCategory(EVENT_TO_GRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+100)
	--e2:SetCondition(s.descon)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e4)
end
function s.lcheck(g,lc,tp)
	return g:GetClassCount(Card.GetCode)==#g
end
function s.spfilter(c)
	return c:IsSetCard(0x1034) and (not c:IsOnField() or c:IsFaceup())
end
function s.tgfilter(c)
	local code=c:GetCode()
	return c:IsSetCard(0x1034) and c:IsAbleToGrave()
end
function s.adfilter(c)
	return c:IsSetCard(0x2034) or (c:IsSetCard(0x34) and c:IsType(TYPE_SPELL+TYPE_TRAP))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
		if Duel.IsExistingMatchingCard(s.adfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(51435705,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,s.adfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
				
				local cb=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil):GetClassCount(Card.GetCode)
				if cb>6 then
					local c=e:GetHandler()
					if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_SET_ATTACK_FINAL)
					e1:SetValue(4000)
					e1:SetReset(RESET_EVENT+0x1ff0000)
					c:RegisterEffect(e1)
				end
			end
		end	
	end
end

function s.cfilter(c,tp,zone,rp)
    local seq=c:GetPreviousSequence()
    if c:GetPreviousControler()~=tp then end
    return ((c:IsReason(REASON_BATTLE)) or (c:IsReason(REASON_EFFECT) and rp~=tp)) and c:IsSetCard(0x2034) 
        and c:IsPreviousLocation(LOCATION_MZONE)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	--local zone=e:GetHandler():GetLinkedZone()
    return eg:IsExists(s.cfilter,1,nil,tp)
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=eg:Filter(s.cfilter,nil,tp)
    local atk=0
    for tc in aux.Next(g) do
        atk=atk | tc:GetBaseAttack()
    end
    if chk==0 then
        return atk~=0 
    end
    e:SetLabel(atk)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local rec=Duel.Damage(1-tp,e:GetLabel(),REASON_EFFECT)
    Duel.Recover(tp,rec,REASON_EFFECT)
end
