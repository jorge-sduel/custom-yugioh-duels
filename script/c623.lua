--
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.list={[70902743]=624,[70781052]=684,[67508932]=902,[21858819]=903}
function s.filter(c,tp)
	local code=c:GetCode()
	local tcode=s.list[code]
	return c:IsFaceup() and tcode 
	--and c:IsReleasableByEffect()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.filter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	--Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=Duel.GetFirstTarget()
	local code=tc:GetCode()
	local mg=tc:GetOverlayGroup()
	local tcode=s.list[code]
	Duel.SendtoGrave(mg,REASON_COST)
	if tc and tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,-2,REASON_RULE)>0 then
		local token=Duel.CreateToken(tp,tcode)
		Duel.ConfirmCards(1-tp,token)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		token:SetStatus(STATUS_PROC_COMPLETE,true) 
		token:SetMaterial(tc)
		Duel.Overlay(token,mg)
	end
	Duel.SpecialSummonComplete()
end
