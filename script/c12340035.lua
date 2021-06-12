--External Worlds Link 3
--Scripted by Secuter
local s,id=GetID()
function s.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	Link.AddProcedure(c,nil,3,nil,s.linkcheck)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--material check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(s.val)
	e3:SetLabelObject(e1)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function s.linkcheck(g,lc,tp)
	return g:GetClassCount(Card.GetAttribute)==g:GetCount()
end

function s.attrfilter(c,e,tp,attr)
    return c:IsFaceup() and c:IsAttribute(attr) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.spfilter(c,e,tp)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 and (Duel.GetLocationCount(tp,LOCATION_MZONE)<3 or Duel.IsPlayerAffectedByEffect(tp,59822133)) then return false end
    local attr={}
	local cc=0
	local res=e:GetLabel()
	for i=0,6 do
		local t = 2^i
		if bit.band(res,t)==t then
			if chk==0 and not Duel.IsExistingMatchingCard(s.attrfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp,t) then return false end
			attr[cc]=t
			cc=cc+1
		end
	end
    if chk==0 then return cc>=3 end
	local sg=Group.CreateGroup()
    for i=0,cc-1 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,s.attrfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp,attr[i])
		sg:Merge(g1)
	end
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg,cc,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
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

function s.con(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local res=e:GetLabel()
	for i=0,6 do
		local t = 2^i
		if bit.band(res,t)==t then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(s.immfilter)
			e1:SetLabel(t)
			e:GetHandler():RegisterEffect(e1)
		end
    end
end
function s.immfilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsAttribute(e:GetLabel())
end

function s.val(e,c)
	local attr=0
	local g=c:GetMaterial()
	for i=0,6 do
		local t = 2^i
		if g:IsExists(Card.IsAttribute,1,nil,t) then
			attr=attr+t
			
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_MZONE)
			e1:SetValue(s.immfilter)
			e1:SetLabel(t)
			e:GetHandler():RegisterEffect(e1)
		end
	end
	e:GetLabelObject():SetLabel(attr)
	local str=c:GetCode()..":SummonAttributes:"
	if attr & ATTRIBUTE_EARTH == ATTRIBUTE_EARTH then str=str.."ATTRIBUTE_EARTH|" end
	if attr & ATTRIBUTE_WATER == ATTRIBUTE_WATER then str=str.."ATTRIBUTE_WATER|" end
	if attr & ATTRIBUTE_FIRE == ATTRIBUTE_FIRE then str=str.."ATTRIBUTE_FIRE|" end
	if attr & ATTRIBUTE_WIND == ATTRIBUTE_WIND then str=str.."ATTRIBUTE_WIND|" end
	if attr & ATTRIBUTE_LIGHT == ATTRIBUTE_LIGHT then str=str.."ATTRIBUTE_LIGHT|" end
	if attr & ATTRIBUTE_DARK == ATTRIBUTE_DARK then str=str.."ATTRIBUTE_DARK|" end
	if attr & ATTRIBUTE_DIVINE == ATTRIBUTE_DIVINE then str=str.."ATTRIBUTE_DIVINE|" end
	Debug.Message(str)
end