--HDi・エクシーズ 
--Hyper-Dimension Xyz
--Created and scripted by Eerie Code
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	--e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 and Duel.CheckLPCost(tp,1500) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabelObject(e)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.sumlimit)
	Duel.RegisterEffect(e1,tp)
	e:SetLabelObject(e1)
	Duel.PayLPCost(tp,1500)
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return e:GetLabelObject()~=se
end
function s.filter(c,g,tp)
	local mg=g:Filter(Card.IsCode,nil,c:GetCode())
	return Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
end
function s.mfilter(c,g,tg,ct,tp)
	local mg=g:Filter(Card.IsCode,nil,c:GetCode())
	local xct=ct+1
	mg:RemoveCard(c)
	tg:AddCard(c)
	local res=false
	if xct==3 then
		local res=Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,tg,ct)
	else
		local res=mg:IsExists(s.mfilter,1,c,mg,tg,xct,tp)
	end
	tg:RemoveCard(c)
	return res
end
function s.xyzfilter(c,g,tg,ct,tp)
	return c:IsXyzSummonable(nil,g,ct,ct)
end
function s.matcond(sg,e,tp)
	return sg:GetClassCount(Card.GetCode)==1 and Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,sg)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.xyzmatfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	if chk==0 then return g:IsExists(s.filter,1,nil,g,tp) and
		Duel.GetLocationCountFromEx(tp,tp,g:Filter(Card.IsLocation,nil,LOCATION_MZONE))>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.xyzmatfilter,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local mg=g:Filter(s.filter,nil,g,tp)
	if #mg<2 then return end
	local matg=aux.SelectUnselectGroup(mg,e,tp,1,99,s.matcond,1,tp,HINTMSG_XMATERIAL)
	local xyzg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil,matg)
	if #xyzg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		matg:KeepAlive()
		Duel.XyzSummon(tp,xyz,nil,matg,99,99)
local sg=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_DECK,0,nil)
	local xg=Duel.GetMatchingGroup(s.setcfilter,tp,LOCATION_EXTRA,0,nil,xyz:GetCode())
	if #xg>0 and #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local xc=xg:Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,xc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sc=sg:Select(tp,1,1,nil):GetFirst()
		Duel.SSet(tp,sc)
		Duel.ConfirmCards(1-tp,sc)
		--e:GetLabelObject():Reset()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(sc:GetActivateEffect())
		e1:SetTargetRange(1,0)
		e1:SetTarget(s.sumlimit)
		Duel.RegisterEffect(e1,tp)
	  end
	end
end
function s.setcfilter(c,cd)
	return c:IsType(TYPE_XYZ) and Card.ListsCode(c,cd) and not c:IsCode(cd) and c:IsFacedown()
end
function s.setfilter(c)
	return c:GetType()==TYPE_SPELL and c:IsSetCard(0x95) and c:IsSSetable()
end
