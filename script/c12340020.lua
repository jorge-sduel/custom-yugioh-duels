--External Worlds Double Synchro
--Scripted by Secuter
function c12340020.initial_effect(c)
	--synchro summon

Synchro.AddProcedure(c,nil,2,2,Synchro.NonTuner(Card.IsType,TYPE_SYNCHRO),1,1)
	c:EnableReviveLimit()
    --Destroy all
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340020,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c12340020.decon)
	e2:SetTarget(c12340020.destg)
	e2:SetOperation(c12340020.desop)
	c:RegisterEffect(e2)
	--Destroy replace
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12340020,1))
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,12340020)
	e3:SetTarget(c12340020.desreptg)
	e3:SetOperation(c12340020.desrepop)
	c:RegisterEffect(e3)
end
function c12340020.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c12340020.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end

function c12340020.decon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c12340020.repfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function c12340020.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c12340020.repfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,c) end
	if Duel.SelectYesNo(tp,aux.Stringid(12340020,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c12340020.repfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,c)
		e:SetLabelObject(g:GetFirst())
		Duel.HintSelection(g)
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c12340020.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
end