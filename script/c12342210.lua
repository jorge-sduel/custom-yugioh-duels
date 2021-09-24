--Bulwark Champion Dailormian
--Scripted by Secuter
local s,id=GetID()
if not ARMOR_IMPORTED then Duel.LoadScript("proc_armor.lua") end
s.armor_Atk=600
s.armor_Def=0
s.is_armor=true
s.is_armorizing=true
function s.initial_effect(c)
	--armorizing summon
	c:EnableReviveLimit()
	aux.AddArmorizingProcedure(c,s.matfilter,2)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetType(EFFECT_TYPE_XMATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(aux.ArmorCondition)
	e1:SetValue(s.armor_Atk)
	c:RegisterEffect(e1)
	--lv
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EFFECT_UPDATE_LEVEL)
	e2:SetType(EFFECT_TYPE_XMATERIAL)
	e2:SetCondition(aux.ArmorCondition)
	e2:SetValue(2)
	c:RegisterEffect(e2)
	--armor:attach
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_ATTACH_ARMOR)
	e3:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1,id)
	e3:SetCondition(aux.ArmorCondition)
	e3:SetTarget(s.attg)
	e3:SetOperation(s.atop)
	c:RegisterEffect(e3)
	--attach
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_ATTACH_ARMOR)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,id+30)
	e4:SetCondition(s.atcon2)
	e4:SetTarget(s.attg2)
	e4:SetOperation(s.atop2)
	c:RegisterEffect(e4)
	--bounce
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,2))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetCountLimit(1,id+60)
	e5:SetTarget(s.thtg)
	e5:SetOperation(s.thop)
	c:RegisterEffect(e5)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,3))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATTACH_ARMOR)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e5:SetCountLimit(1,id+80)
	e6:SetCondition(s.spcon)
	e6:SetTarget(s.sptg)
	e6:SetOperation(s.spop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e7)
end
s.listed_series={0x21a}
function s.matfilter(c,lc,sumtype,tp)
	return c:IsLevelAbove(6) and c:IsRace(RACE_WARRIOR,lc,sumtype,tp)
end

function s.atfilter(c,tc)
	return c:IsSetCard(0x21a) and not c:IsCode(id)
end
function s.attg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.atfilter(chkc,e:GetHandler()) end
	if chk==0 then return Duel.IsExistingTarget(s.atfilter,tp,LOCATION_GRAVE,0,1,nil,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACH_ARMOR)
	local g=Duel.SelectTarget(tp,s.atfilter,tp,LOCATION_GRAVE,0,1,1,nil,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_ATTACH_ARMOR,g,1,0,0)
end
function s.atop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Auxiliary.AttachArmor(e:GetHandler(),tc)
	end
end

function s.atcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_TYPE_ARMORIZING
end
function s.atfilter2(c)
	return c:IsSetCard(0x21a) and c.is_armor
end
function s.attg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(s.atfilter2,tp,LOCATION_GRAVE,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_ATTACH_ARMOR,nil,1,0,0)
end
function s.rescon(sg,e,tp,mg)
	return aux.ChkfMMZ(1)(sg,e,tp,mg) and sg:GetClassCount(Card.GetCode)==#sg
end
function s.atop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local rg=Duel.GetMatchingGroup(s.atfilter2,tp,LOCATION_GRAVE,0,nil,c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACH_ARMOR)
		local g=aux.SelectUnselectGroup(rg,e,tp,1,5,s.rescon,1,tp,HINTMSG_SELECT,nil,nil,true)
		if #g>0 then
			Auxiliary.AttachArmor(c,g)
		end
	end
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsAbleToHand() end
	local ct=e:GetHandler():GetOverlayCount()
	if chk==0 then return ct>0 and Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end

function s.atfilter3(c,sc)
	return c:IsFaceup() and c.is_armor
end
function s.attg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.atfilter3,tp,LOCATION_MZONE,0,1,nil,e:GetHandler()) end
	local g=Duel.SelectTarget(tp,s.atfilter3,tp,LOCATION_MZONE,0,1,1,nil,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_ATTACH_ARMOR,g,1,0,0)
end
function s.atop3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Auxiliary.AttachArmor(tc,e:GetHandler())
	end
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_TYPE_ARMORIZING
		and c:IsReason(REASON_EFFECT) and rp~=tp and c:IsPreviousControler(tp)
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end
function s.spfilter(c,e,tp,ar)
	return c:IsSetCard(0x21a) and c:IsRace(RACE_WARRIOR) and c:IsLevelBelow(4)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter(chkc,e,tp,c) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		tc:CompleteProcedure()
		local c=e:GetHandler()
		if c and c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) and Armor.AttachCheck(c,tc) then
			Duel.BreakEffect()
			Auxiliary.AttachArmor(tc,c)
		end
	end
end
