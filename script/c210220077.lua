--HDi・リチューアル
--Hyper-Dimension Ritual
--Created and scripted by Eerie Code
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1500) end
	Duel.PayLPCost(tp,1500)
end
function s.filter(c,e,tp,m,m2,ft)
	if not (c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,true)) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	mg:Merge(m2)
	if c.ritual_custom_condition then
		res=c:ritual_custom_condition(mg,ft,"equal")
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
	end
	if ft>0 then
		res=mg:CheckWithSumEqual(Card.GetOriginalLevel,c:GetOriginalLevel()*2,2,99,c)
	else
		res=mg:IsExists(s.filterf,1,nil,tp,mg,c)
	end
	return res
end
function s.filterf(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5 then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumEqual(Card.GetOriginalLevel,rc:GetOriginalLevel()*2,1,99,rc)
	else return false end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		local mg=Duel.GetRitualMaterial(tp)
		local mg2=Group.CreateGroup()
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return ft>-1 and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_ALL-LOCATION_MZONE,0,1,nil,e,tp,mg,mg2,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_ALL-LOCATION_MZONE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_BECOME_LINKED_ZONE)
	e1:SetValue(0xffffff)
	Duel.RegisterEffect(e1,tp)
	local mg=Duel.GetRitualMaterial(tp)
	local mg2=Group.CreateGroup()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_ALL-LOCATION_MZONE,0,1,1,nil,e,tp,mg,mg2,ft)
	local tc=tg:GetFirst()
	if tc then
		local mat=nil
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(mg2)
		if tc.ritual_custom_operation then
			tc:ritual_custom_operation(mg,"equal")
			mat=tc:GetMaterial()
		else
			local lv=tc:GetOriginalLevel()*2
			if ft>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				mat=mg:SelectWithSumEqual(tp,Card.GetOriginalLevel,lv,1,99,tc)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				mat=mg:FilterSelect(tp,s.filterf,1,1,nil,tp,mg,tc)
				Duel.SetSelectedCard(mat)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
				local mat2=mg:SelectWithSumEqual(tp,Card.GetOriginalLevel,lv,0,99,tc)
				mat:Merge(mat2)
			end
			tc:SetMaterial(mat)
		end
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_BASE_ATTACK)
		e2:SetValue(tc:GetAttack()*2)
		e2:SetReset(RESET_EVENT|RESETS_STANDARD)
		tc:RegisterEffect(e2)
		tc:CompleteProcedure()
	end
	e1:Reset()
end
