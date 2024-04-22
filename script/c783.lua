--
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,nil,5,3)
--
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.condition1)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
		--Adjust
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(id)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(function(e) return e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED) end)
	c:RegisterEffect(e2)
	--Cannot Normal Summon, Special Summon or Flip Summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_FORCE_SPSUMMON_POSITION)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetTarget(s.sumlimit)
	e3:SetValue(POS_FACEDOWN)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e5)
	aux.GlobalCheck(s,function()
		s.lastFieldId={}
		s.lastFieldId[0]=nil
		s.lastFieldId[1]=nil
		local ge=Effect.GlobalEffect()
		ge:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		ge:SetCode(EVENT_ADJUST)
		ge:SetOperation(s.adjustop)
		Duel.RegisterEffect(ge,0)
	end)
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	local tp=sump
	if targetp then tp=targetp end
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,c:GetCode()),tp,LOCATION_MZONE,0,1,c)
end
function s.fidfilter(c,fid)
	return c:GetFieldID()>fid
end
local faceupfil=aux.FaceupFilter(Card.IsHasEffect,id)
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	if not Duel.IsExistingMatchingCard(faceupfil,0,0,LOCATION_MZONE,1,nil) then
		s.lastFieldId[0]=nil
		s.lastFieldId[1]=nil
		return
	end
	local sg=Group.CreateGroup()
	for p=0,1 do
		local g=Duel.GetMatchingGroup(Card.IsFaceup,p,LOCATION_MZONE,0,nil)
		if #g==0 then
			s.lastFieldId[p]=nil
		else
			local code=1
			local update_fid=false
			while code~=0 do
				local rg=g:Filter(Card.IsCode,nil,code)
				if s.lastFieldId[p] then
					local forced
					forced,rg=rg:Split(s.fidfilter,nil,s.lastFieldId[p])
					if #rg==0 then
						rg=forced
						update_fid=true
					else
						sg:Merge(forced)
					end
				end
				local rc=#rg
				if rc>1 then
					Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOGRAVE)
					sg:Merge(rg:Select(p,rc-1,rc-1,nil))
				end
				race=race<<1
			end
			if update_fid or not s.lastFieldId[p] then
				local maxg,maxid=g:Sub(sg):GetMaxGroup(Card.GetFieldID)
				s.lastFieldId[p]=maxid
			end
		end
	end
	local p=e:GetHandlerPlayer()
	local g1,g2=Group.CreateGroup(),Group.CreateGroup()
	local readjust=false
	if #sg>0 then
		g1,g2=sg:Split(Card.IsControler,nil,p)
	end
	if #g1>0 then
		Duel.SendtoGrave(g1,REASON_RULE,PLAYER_NONE,p)
		readjust=true
	end
	if #g2>0 then
		Duel.SendtoGrave(g2,REASON_RULE,PLAYER_NONE,1-p)
		readjust=true
	end
	if readjust then Duel.Readjust() end
end
function s.filter1(c)
	return c:IsFaceup()
end
function s.filter2(c)
	return c:IsFaceup()
end
function s.condition1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,23649496)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and s.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter1,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingMatchingCard(s.filter2,tp,0,LOCATION_MZONE,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.filter1,tp,0,LOCATION_MZONE,1,1,nil)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local g=Duel.GetMatchingGroup(s.filter2,tp,0,LOCATION_MZONE,tc)
		local lc=g:GetFirst()
		local code=tc:GetCode()
		for lc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetValue(code)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			lc:RegisterEffect(e1)
		end
	end
end
