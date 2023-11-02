--オッドアイズ・カタストロフ
--Odd-Eyes Catastrophe
--Created and scripted by Eerie Code
local s,id=GetID()
function s.initial_effect(c)
	--activate
	--synchro effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.sctg)
	e1:SetOperation(s.scop)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)>100 end
	Duel.SetLP(tp,100)
end
function s.filter2(c,e,tp,m)
	return c:IsType(TYPE_FUSION) and c:CheckFusionMaterial(m)
end
function s.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.scop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(Card.IsCanBeSynchroMaterial,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil,mg)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local sc=sg:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		e1:SetOperation(s.regop)
		sc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		e2:SetOperation(s.regop2)
		sc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_SPSUMMON_SUCCESS)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		e3:SetOperation(s.regop3)
		sc:RegisterEffect(e3)
		Duel.SynchroSummon(tp,sc,nil,mg)
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	local sg=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg)
	if sg:GetCount()>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=sg:Select(tp,1,1,nil)
	local tc=tg:GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	local mat=Duel.SelectFusionMaterial(tp,tc,mg)
	Duel.ConfirmCards(1-tp,mat)
	tc:SetMaterial(mat)
	Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	tc:CompleteProcedure() 
	end
end
function s.regop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	local lv=mg:Select(tp,1,1,nil)
	for tc in mg:Iter() do
	if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_XYZ_LEVEL)
	e2:SetValue(lv:GetFirst():GetLevel())
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e2,true)
  end
--e1:Reset()
end
end
function s.regop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	--[[local lv=mg:Select(tp,1,1,nil)
	for tc in mg:Iter() do
	if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_XYZ_LEVEL)
	e2:SetValue(lv:GetFirst():GetLevel())
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e2,true)
	Duel.SpecialSummonComplete()]]
	local g=Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil,nil,mg)
	local sg2=g:Select(tp,1,1,nil)
	local sc=sg2:GetFirst() 
	Duel.XyzSummon(tp,sc,nil,mg,99,99)
  --[[end
--e1:Reset()
end]]
end
