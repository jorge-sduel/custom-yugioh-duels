--Transfigured, Frozen Lake
c986903210.Is_Runic=true
if not Rune then Duel.LoadScript("proc_rune.lua") end
function c986903210.initial_effect(c)
	--rune procedure
	c:EnableReviveLimit()
	Rune.AddProcedure(c,Rune.MonFunction(c986903210.matfilter1),2,2,Rune.STFunction(c986903210.matfilter2),2,2)
	--cannot special summon
	--local e1=Effect.CreateEffect(c)
	--e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	--e1:SetType(EFFECT_TYPE_SINGLE)
	--e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	--e1:SetValue(c986903210.runlimit)
	--c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(66141736,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c986903210.sptg)
	e2:SetOperation(c986903210.spop)
	c:RegisterEffect(e2)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(95457011,1))
	e4:SetCategory(CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetTarget(c986903210.settg)
	e4:SetOperation(c986903210.setop)
	c:RegisterEffect(e4)
end
function c986903210.matfilter1(c)
	return c:IsType(TYPE_MONSTER) and (c:GetAttack()==0 or c:GetDefense()==0)
end
function c986903210.matfilter2(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c986903210.runfilter1(c)
	return c986903210.matfilter1(c) and Duel.IsExistingMatchingCard(c986903210.matfilter2,c:GetControler(),LOCATION_ONFIELD,0,2,c)
end
function c986903210.runcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(c986903210.runfilter1,c:GetControler(),LOCATION_MZONE,0,2,nil)
end
function c986903210.runop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Group.CreateGroup()
	local mt1=Duel.SelectMatchingCard(tp,c986903210.runfilter1,c:GetControler(),LOCATION_MZONE,0,2,2,nil,c)
	local g2=Duel.GetMatchingGroup(c986903210.matfilter2,tp,LOCATION_ONFIELD,0,nil,c)
	g:Merge(mt1)
	g2:Sub(mt1)
	local mt2=g2:Select(tp,2,2,nil)
	g:Merge(mt2)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_RUNIC)
end
function c986903210.runlimit(e,se,sp,st)
	return bit.band(st,0x4f000000)==0x4f000000
end
function c986903210.spfilter(c,e,tp)
	return c:GetLevel()==1 and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c986903210.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c986903210.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c986903210.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c986903210.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c986903210.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
			local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_UPDATE_ATTACK)
			e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e4:SetRange(LOCATION_MZONE)
			e4:SetValue(e:GetHandler():GetBaseAttack())
			e4:SetReset(RESET_EVENT+0xff0000)
			tc:RegisterEffect(e4)
			local e5=Effect.CreateEffect(e:GetHandler())
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetCode(EFFECT_CHANGE_LEVEL)
			e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e5:SetRange(LOCATION_MZONE)
			e5:SetValue(e:GetHandler():GetRank())
			e5:SetReset(RESET_EVENT+0xff0000)
			tc:RegisterEffect(e5)
	end
end
function c986903210.filter(c)
	return c:IsType(TYPE_SPELL) and c:IsSSetable()
end
function c986903210.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c986903210.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c986903210.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c986903210.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end
