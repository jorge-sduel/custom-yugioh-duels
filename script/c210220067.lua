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
	e1:SetTarget(s.sctg)
	e1:SetOperation(s.scop)
	c:RegisterEffect(e1)
end
function s.filter2(c,m)
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
		Duel.SynchroSummon(tp,sc,nil,mg)
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	local g=Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil,nil,mg)
	local g2=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,nil,mg)
	local sg=g:Select(tp,1,1,nil)
	local sc=sg:GetFirst()
	local sg2=g2:Select(tp,1,1,nil)
	local sc2=sg2:GetFirst()
	local mat=Duel.SelectFusionMaterial(tp,sc2,mg)
	Duel.ConfirmCards(1-tp,mat)
	sc2:SetMaterial(mat)
	Duel.XyzSummon(tp,sc,nil,mg,99,99)
	Duel.SpecialSummon(sc2,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	sc2:CompleteProcedure()
end
