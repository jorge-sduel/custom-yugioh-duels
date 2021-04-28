--Triple Attribute Link
function c12340034.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	Link.AddProcedure(c,nil,3,nil,c12340034.linkcheck)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340034,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c12340034.spcost)
	e2:SetTarget(c12340034.sptg)
	e2:SetOperation(c12340034.spop)
	c:RegisterEffect(e2)
	--material check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c12340034.val)
	e3:SetLabelObject(e1)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end

function c12340034.linkcheck(g,lc,tp)
	return g:GetClassCount(Card.GetAttribute)==g:GetCount()
end

function c12340034.attrfilter(c,e,tp,attr)
    return c:IsFaceup() and c:IsAttribute(attr) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12340034.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c12340034.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12340034.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 and (Duel.GetLocationCount(tp,LOCATION_MZONE)<3 or Duel.IsPlayerAffectedByEffect(tp,59822133)) then return false end
    local attr={}
	local cc=0
	local res=e:GetLabel()
	for i=0,6 do
		local t = math.pow(2, i)
		if bit.band(res,t)==t then
			if chk==0 and not Duel.IsExistingMatchingCard(c12340034.attrfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp,t) then return false end
			attr[cc]=t
			cc=cc+1
		end
	end
    if chk==0 then return cc>=3 end
	local sg=Group.CreateGroup()
    for i=0,cc-1 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,c12340034.attrfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp,attr[i])
		sg:Merge(g1)
	end
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,cc,0,0)
end
function c12340034.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if ft<=0 or g:GetCount()==0 or (g:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then return end
	if g:GetCount()<=ft then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,ft,ft,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		g:Sub(sg)
		Duel.SendtoGrave(g,REASON_RULE)
	end
end


function c12340034.con(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c12340034.op(e,tp,eg,ep,ev,re,r,rp)
	local res=e:GetLabel()
	for i=0,6 do
		local t = math.pow(2, i)
		if bit.band(res,t)==t then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(c12340034.immfilter)
			e1:SetLabel(t)
			e:GetHandler():RegisterEffect(e1)
		end
    end
end
function c12340034.immfilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsAttribute(e:GetLabel())
end

function c12340034.val(e,c)
	local attr=0
	local g=c:GetMaterial()
	for i=0,6 do
		local t = math.pow(2, i)
		if g:IsExists(Card.IsAttribute,1,nil,t) then
			attr=attr+t
			
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(c12340034.immfilter)
			e1:SetLabel(t)
			e:GetHandler():RegisterEffect(e1)
		end
	end
	e:GetLabelObject():SetLabel(attr)
end