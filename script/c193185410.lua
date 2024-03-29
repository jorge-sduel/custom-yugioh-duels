--created by Swag, coded by Lyris
local cid,id=GetID()
cid.IsTimeleap=true
if not TIMELEAP_IMPORTED then Duel.LoadScript("proc_timeleap.lua") end
function cid.initial_effect(c)
	c:EnableReviveLimit()
	  --synchro summon
	--time leap procedure
Timeleap.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_ZOMBIE),1,1,cid.TimeCon,nil,nil,nil,2)
	--aux.AddTimeleapProc(c,5,function(e,tc) return Duel.IsExistingMatchingCard(cid.mfilter,tc:GetControler(),LOCATION_GRAVE,0,1,nil) end,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),cid.sumop)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end)
	e1:SetCost(cid.cost)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetCondition(function(e,tp,eg) return eg:IsExists(cid.cfilter,1,nil,tp) end)
	e2:SetCost(function(e) e:SetLabel(100) return true end)
	e2:SetTarget(cid.sptg)
	e2:SetOperation(cid.spop)
	c:RegisterEffect(e2)
		--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	--e3:SetCountLimit(1)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(cid.damcon)
	e3:SetTarget(cid.damtg)
	e3:SetOperation(cid.damop)
	c:RegisterEffect(e3)
end
function cid.material(c)
	return c:IsLevelAbove(5) and c:IsSetCard(0xd78) and c:IsType(TYPE_MONSTER)
end
function cid.TimeCon(e,c)
	if c==nil then return true end
	return Duel.GetMatchingGroupCount(cid.material,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)>=1
end
function cid.sumop(e,tp,eg,ep,ev,re,r,rp,c,g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_TIMELEAP)
	aux.TimeleapHOPT(tp)
end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.AND(Card.IsSetCard,Card.IsDiscardable),tp,LOCATION_HAND,0,1,nil,0xd78) end
	Duel.DiscardHand(tp,aux.AND(Card.IsSetCard,Card.IsDiscardable),1,1,REASON_COST+REASON_DISCARD,nil,0xd78)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsControlerCanBeChanged() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,Duel.SelectTarget(tp,Card.IsControlerCanBeChanged,tp,0,LOCATION_MZONE,1,1,nil),1,0,0)
end
function cid.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.GetControl(tc,tp,PHASE_END,1) end
end
function cid.cfilter(c,tp)
	return c:IsFaceup() and c:IsLevelAbove(5) and c:IsControler(tp) and c:IsRace(RACE_ZOMBIE)
end
function cid.filter1(c,e,tp)
	local lv=c:GetLevel()
	return lv>0 and c:IsFaceup() and c:IsSetCard(0xd78)
		and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(cid.filter2,tp,LOCATION_DECK,0,1,nil,lv,e,tp)
end
function cid.filter2(c,lv,e,tp)
	return c:IsSetCard(0xd78) and c:GetLevel()<lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cid.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.CheckReleaseGroup(tp,cid.filter1,1,nil,e,tp)
	end
	local rg=Duel.SelectReleaseGroup(tp,cid.filter1,1,1,nil,e,tp)
	e:SetLabel(rg:GetFirst():GetLevel())
	Duel.Release(rg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cid.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	Duel.SpecialSummon(Duel.SelectMatchingCard(tp,cid.filter2,tp,LOCATION_DECK,0,1,1,nil,e:GetLabel(),e,tp),0,tp,tp,false,false,POS_FACEUP)
end
function cid.filter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsRace(RACE_ZOMBIE)
end
function cid.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cid.filter,1,nil,tp) and e:GetHandler():IsSummonType(SUMMON_TYPE_TIMELEAP2)
end
function cid.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function cid.damop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
	Duel.Recover(tp,1000,REASON_EFFECT)
end
