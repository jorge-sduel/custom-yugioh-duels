--star seraph
local s,id=GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,s.matfilter,4,2)
	c:EnableReviveLimit()
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1,false,REGISTER_FLAG_DETACH_XMAT)
	--Destroy monsters your opponent controls
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(aux.bdocon)
	e2:SetTarget(s.xyztg)
	e2:SetOperation(s.xyzop)
	c:RegisterEffect(e2)
end
function s.matfilter(c)
	return c:IsSetCard(0x86)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
	local rt=math.min(Duel.GetMatchingGroupCount(nil,tp,LOCATION_HAND,0,nil),c:GetOverlayCount())
Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,rt,nil)
	local ct=c:RemoveOverlayCard(tp,1,rt,REASON_COST)
	e:SetLabel(ct)
end
function s.tdfilter(c)
	return c:IsAbleToDeck()
end
function s.filter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_HAND,0,1,nil) 
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.filter),tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,3,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,3,tp,LOCATION_GRAVE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local tdg=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_GRAVE,0,nil)
	if #tdg>=ct then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local tdsg=tdg:Select(tp,ct,ct,nil)
		if Duel.SendtoGrave(tdsg,REASON_EFFECT)>ct-1 then
			local thg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.filter),tp,LOCATION_GRAVE,0,nil)
			if #thg>=ct then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
				local thsg=thg:Select(tp,ct,ct,nil)
				Duel.BreakEffect()
				Duel.SendtoHand(thsg,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,thsg)
			end
		end
	end
end
function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(tp,1)
	if c:IsRelateToEffect(e) and #g==1 then
		Duel.DisableShuffleCheck()
		Duel.Overlay(c,g)
	if g:IsSetCard(0x86) and g:IsMonster() then
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g1:GetCount()>0 then
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	  end
	 end 
	end
end
