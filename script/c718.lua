--No.c93 希望皇ホープ・カイザー
--Number c93: Utopia Kaiser
local s,id=GetID()
Duel.LoadCardScript("c12744567.lua")
function s.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,s.xyzfilter,nil,4,nil,nil,4,nil,false)
	aux.EnableCheckRankUp(c,nil,nil,23187256)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.sincurseval)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabelObject(e3) 
	e3:SetOperation(s.operation2)
	e3:SetCost(s.cost)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_RANKUP_EFFECT)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4,false,REGISTER_FLAG_DETACH_XMAT)
end
s.listed_series={0x48}
s.xyz_number=93
function s.xyzfilter(c,xyz,sumtype,tp)
	return c:IsType(TYPE_XYZ,xyz,sumtype,tp) and c:IsSetCard(0x48,xyz,sumtype,tp) and c:GetOverlayCount()>0
end
function s.xyzcheck(g,tp,xyz)
	local mg=g:Filter(function(c) return not c:IsHasEffect(511001175) end,nil)
	return mg:GetClassCount(Card.GetRank)==1
end
function s.check(c,rk)
	return c:GetRank()~=rk and not c:IsHasEffect(511001175)
end
function s.filter(c,e,tp,rp)
	return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp,rp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.gfilter(c,tp,rp,rank)
	return not c:IsRank(rank)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then ct=1 end
	ct=math.min(ct,aux.CheckSummonGate(tp) or ct)
	if ct>0 then
		local g1=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,0,nil,e,tp,rp)
		if #g1>0 then
			repeat
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tc=g1:Select(tp,1,1,nil):GetFirst()
				Duel.SpecialSummonStep(tc,0,tp,tp,true,true,POS_FACEUP)
				g1:Match(s.gfilter,nil,tp,rp,0)
				ct=ct-1
			until #g1==0 or ct==0 or not Duel.SelectYesNo(tp,aux.Stringid(id,1))
			Duel.SpecialSummonComplete()
			Duel.BreakEffect()
		end
	end
end
function s.sincursefilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function s.sincurseval(e,c)
	local c=e:GetHandler()
	local ATK=0
	local g=Duel.GetMatchingGroup(s.sincursefilter,e:GetOwnerPlayer(),LOCATION_MZONE,0,c)
	local tc=g:GetFirst()
	while tc do
	ATK=ATK+tc:GetAttack()
	tc=g:GetNext()
	end
	return ATK
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local g=e:GetHandler():GetOverlayGroup()
	Duel.SendtoGrave(g,REASON_COST)
end
function s.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--prevent activations for the rest of that battle phas
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_TURN)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_SKIP_TURN)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e2,tp)
end
