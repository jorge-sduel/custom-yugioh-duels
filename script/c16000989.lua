--Conjoint Sorceress
local s,id=GetID()
function s.initial_effect(c)
s.Is_EvolSyn=true
s.Is_Evolute=true
if not EVOLUTE_IMPORTED then Duel.LoadScript("proc_evolute.lua") end
	--c:EnableCounterPermit(0x88)
	c:EnableReviveLimit()
	Synchro.AddProcedure(c,Card.IsEvoluteTuner,2,99,Synchro.NonTunerEx(Card.IsEvolute),1,99)
aux.AddEcProcedure(c,SUMMON_TYPE_SYNCHRO)
	--Activate a card
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCost(s.cost)
	e1:SetCondition(s.condition)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	--When this card is Evolute Summoned:You can Conjoint 1 monster from your hand to this card. (HOpT)
	--If this card is Conjointed with another card: You can remove 4 E-C from this card; Special Summon 2 monsters from your Deck with the Same name of the Conjoint momster to this card, also negate their effects, and cannot be used as Materials for a Summon, except Evolute Materials for a Summon. (HOpT)
	--local e1=Effect.CreateEffect(c)
	--e1:SetDescription(aux.Stringid(16000989,0))
	--e1:SetCategory(CATEGORY_DRAW)
	--e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	--e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	--e1:SetCountLimit(1,16000989)
	--e1:SetCondition(c16000989.drcon)
	--e1:SetTarget(c16000989.drtg)
	--e1:SetOperation(c16000989.drop)
	--c:RegisterEffect(e1)
	--special summon
	--local e2=Effect.CreateEffect(c)
	--e2:SetDescription(aux.Stringid(16000989,1))
	--e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	--e2:SetType(EFFECT_TYPE_IGNITION)
	--e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	--e2:SetRange(LOCATION_MZONE)
	--e2:SetCountLimit(1,16000990)
	--e2:SetCondition(c16000989.condition)
	--e2:SetCost(c16000989.cost)
	--e2:SetTarget(c16000989.target)
	--e2:SetOperation(c16000989.activate)
	--c:RegisterEffect(e2)
	--Limit batlle target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	--e4:SetCondition(s.atcon)
	e4:SetValue(s.atlimit)
	c:RegisterEffect(e4)
end
function s.rcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsType,1,nil,TYPE_TUNER)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	   if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x111f,2,REASON_COST) end
	e:GetHandler():RemoveCounter(tp,0x111f,2,REASON_COST)
end
function s.tffilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:CheckActivateEffect(false,false,false)~=nil
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttackTarget()
		and Duel.IsExistingMatchingCard(s.tffilter,tp,LOCATION_DECK,0,1,nil)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,s.tffilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	local tpe=tc:GetType()
	local te=tc:GetActivateEffect()
	local tg=te:GetTarget()
	local co=te:GetCost()
	local op=te:GetOperation()
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	Duel.ClearTargetCard()
	local loc=LOCATION_SZONE
	if (tpe&TYPE_FIELD)~=0 then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then Duel.SendtoGrave(fc,REASON_RULE) end
		if Duel.GetFlagEffect(tp,62765383)>0 then
			fc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
			if fc and Duel.Destroy(fc,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
		end
		loc=LOCATION_FZONE
	end
	Duel.MoveToField(tc,tp,tp,loc,POS_FACEUP,true)
	Duel.Hint(HINT_CARD,0,tc:GetCode())
	tc:CreateEffectRelation(te)
	if (tpe&TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)==0 then
		tc:CancelToGrave(false)
	end
	if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
	if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
	Duel.BreakEffect()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g then
		local etc=g:GetFirst()
		while etc do
			etc:CreateEffectRelation(te)
			etc=g:GetNext()
		end
	end
	if op then op(te,tp,eg,ep,ev,re,r,rp) end
	tc:ReleaseEffectRelation(te)
	if etc then
		etc=g:GetFirst()
		while etc do
			etc:ReleaseEffectRelation(te)
			etc=g:GetNext()
		end
	end
end
function s.atlimit(e,c)
	return c~=e:GetHandler()
end
