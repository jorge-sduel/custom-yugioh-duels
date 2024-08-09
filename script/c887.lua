--
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Xyz to material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(s.xmtg)
	e2:SetOperation(s.xmop)
	c:RegisterEffect(e2)
end
s.listed_series={SET_NUMBER,0x1178,0x177}
function s.thfilter(c)
	return c:IsMonster() and (c:IsSetCard(0x177) or c:IsSetCard(0x1178)) and c:IsAbleToHand()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,nil)
	if  #g>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
	local d=Duel.GetMatchingGroup(Card.IsDiscardable,tp,LOCATION_HAND,0,nil)
	if #d>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c)
	local class=c:GetMetatable(true)
	if class==nil then return false end
	local no=class.xyz_number 
	return not (c:IsType(TYPE_XYZ) and no>100 and c:IsSetCard(0x48)) and c:IsLocation(LOCATION_EXTRA)
end
function s.xmfil1(c,tp)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(SET_NUMBER) and Duel.IsExistingMatchingCard(s.xmfil2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,c,c)
end
function s.xmfil2(c,xyzmat)
	return c:IsType(TYPE_XYZ) and xyzmat:IsCanBeXyzMaterial(c)
end
function s.xmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.xmfil1(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.xmfil1,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.xmfil1,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function s.xmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local tcc=Duel.SelectMatchingCard(tp,s.xmfil2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,tc,tc):GetFirst()
		if tcc and not tcc:IsImmuneToEffect(e) then
			Duel.Overlay(tc,tcc,true)
		end
	end
end
