--
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetLabel(0)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
			--salvage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,{id,2})
	e3:SetCost(Cost.AND(aux.bfgcost,s.hcost))
	e3:SetTarget(s.target1)
	e3:SetOperation(s.activate1)
	c:RegisterEffect(e3)
end
s.listed_series={SET_QLI}
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function s.cfilter(c,e,tp,ft)
	local lv=c:GetOriginalLevel()
	local rc=c:GetOriginalRace()
	local att=c:GetOriginalAttribute()
	--[[local eff4064256={Duel.GetPlayerEffect(tp,4064256)}
	for _,te in ipairs(eff4064256) do
		local val=te:GetValue()
		if val and val(te,c,e,0) then rc=val(te,c,e,1) end
	end
	local eff12644061={Duel.GetPlayerEffect(tp,CARD_ADVANCED_DARK)}
	for _,te in ipairs(eff12644061) do
		local val=te:GetValue()
		if val and val(te,c,e,0) then att=val(te,c,e,1) end
	end]]
	return c:IsMonsterCard() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(SET_QLI) and lv>0 and (c:IsLocation(LOCATION_DECK) or c:IsFaceup()) and c:IsAbleToGraveAsCost() and (ft>0 or c:GetSequence()<5)
		and (Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,lv,c:GetCode(),att,e,tp) or Duel.IsExistingMatchingCard(s.pcfilter,tp,LOCATION_DECK,0,1,nil,lv,c:GetCode(),att,e,tp))
end
function s.spfilter(c,lv,rc,att,e,tp)
	return c:IsSetCard(SET_QLI) and c:IsLevel(lv) and not c:IsCode(rc) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		--if e:GetLabel()~=100 then return false end
		--e:SetLabel(0)
		return ft>-1 and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_DECK,0,1,nil,e,tp,ft)
	end
	--e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,ft)
	local tc=g:GetFirst()
	Duel.SendtoGrave(tc,REASON_COST)
	Duel.SetTargetCard(tc)
	local opt=0
	if not Duel.CheckPendulumZones(tp) then
		opt=Duel.SelectOption(tp,aux.Stringid(id,1))
	else
		opt=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	end
	e:SetLabel(opt)
	if opt==0 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetLabel()==0 then
	--[[if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not tc or not tc:IsLocation(LOCATION_GRAVE) or not tc:IsRelateToEffect(e) then return end]]
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetLevel(),tc:GetCode(),tc:GetAttribute(),e,tp)
		--if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	else
	--local tc=Duel.GetFirstTarget()
	local g=Duel.SelectMatchingCard(tp,s.pcfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetLevel(),tc:GetCode(),tc:GetAttribute(),e,tp)
		--if #g>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		-- end
       --end
	end
end
function s.pcfilter(c,lv,rc,att,e,tp)
	return c:IsSetCard(SET_QLI) and c:IsLevel(lv) and not c:IsCode(rc) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function s.costfilter(c)
	return c:IsFaceup() and c:IsSetCard(SET_QLI) and c:IsAbleToHandAsCost()
end
function s.hcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SendtoHand(g,nil,REASON_COST)
end
function s.actfilter(c,tp)
	return c:IsSetCard(SET_QLI) and c:IsType(TYPE_FIELD) and c:IsSpell() and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.actfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function s.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local sc=Duel.SelectMatchingCard(tp,s.actfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	--if not sc then return end
	Duel.ActivateFieldSpell(sc,e,tp,eg,ep,ev,re,r,rp)
--	end
end
