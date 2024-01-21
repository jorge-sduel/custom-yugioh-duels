--モンスターゲート
--Monster Gate
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.cfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0 and c:IsSetCard(0xc0)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.cfilter,1,false,nil,nil,tp) end
	local g=Duel.SelectReleaseGroupCost(tp,s.cfilter,1,1,false,nil,nil,tp)
	Duel.Release(g,REASON_COST)
end
function s.spfilter(c,e,tp,rc)
	return c:IsAttribute(rc) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.filter2(c,att)
	return c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local rc=Duel.AnnounceAttribute(tp,1,ATTRIBUTE_ALL)
	e:SetLabel(rc)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	--if Duel.GetLocationCount(tp,LOCATION_MZONE)<=-1 then return end
		--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,e:GetLabel())
		local g2=Duel.GetMatchingGroup(s.filter2,tp,0,LOCATION_MZONE,c,e:GetLabel()) 
	if #g>0 or #g2>0 then
			Duel.SpecialSummon(g:GetFirst(),0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		--end
		local lc=g2:GetFirst()
		for lc in aux.Next(g2) do
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e2:SetValue(e:GetLabel())
	lc:RegisterEffect(e2)
	--untargetable
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(s.etarget)
	e2:SetValue(1)
	Duel.RegisterEffect(e2)
	--battle target
	local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetTargetRange(LOCATION_MZONE,0) 
	e5:SetTarget(s.etarget)
	e5:SetValue(1)
	Duel.RegisterEffect(e5)
		end
	end
end
function s.etarget(e,c)
	return c:IsMonster() and (c:IsFacedown() or c:IsSetCard(0xbf)) 
end



