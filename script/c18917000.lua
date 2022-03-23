--Timebreaker
function c18917000.initial_effect(c)
    --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetDescription(aux.Stringid(18917000,0))
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c18917000.actcon)
	c:RegisterEffect(e1)
	--Psummon
	--local e2=Effect.CreateEffect(c)
	--e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	--e2:SetCode(EVENT_ADJUST)
	--e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	--e2:SetRange(LOCATION_PZONE)
	--e2:SetTargetRange(0,LOCATION_PZONE)
	--e2:SetOperation(c18917000.psactivate)
	--c:RegisterEffect(e2)
	--opponent splimit
	--local e3=Effect.CreateEffect(c)
	--e3:SetType(EFFECT_TYPE_FIELD)
	--e3:SetRange(LOCATION_PZONE)
	--e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	--e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	--e3:SetTargetRange(0,1)
	--e3:SetCondition(c18917000.psopcon)
	--e3:SetTarget(c18917000.psoplimit)
	--c:RegisterEffect(e3)
	--Self Destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetDescription(aux.Stringid(18917000,1))
	e4:SetOperation(c18917000.selfDes)
	c:RegisterEffect(e4)
	--Special Summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(18917000,2))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetCountLimit(1)
	e5:SetTarget(c18917000.sstg)
	e5:SetOperation(c18917000.ssop)
	c:RegisterEffect(e5)
	--Disact
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_ATTACK_ANNOUNCE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(c18917000.limcon)
	e6:SetOperation(c18917000.limop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e7)
	--Level
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(18917000,3))
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e8:SetCountLimit(1)
	e8:SetTarget(c18917000.lvtg)
	e8:SetOperation(c18917000.lvop)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(1074)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_SPSUMMON_PROC_G)
	e9:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetRange(LOCATION_PZONE)
	e9:SetCondition(c18917000.pencond)
	e9:SetOperation(c18917000.pendop)
	e9:SetValue(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e9)
end
function c18917000.penFilter(c,e,tp,lscale,rscale,lvchk)
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
		and (lvchk or (lv<lscale and lv>rscale) or c:IsHasEffect(511004423)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false)
		and not c:IsForbidden()
end
function c18917000.actcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_MONSTER)
end

function c18917000.limcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsControler(1-tp) then tc=Duel.GetAttackTarget() end
	return tc and tc:IsControler(tp) and tc:IsSetCard(0xb00)
end
function c18917000.limop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c18917000.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c18917000.aclimit(e,re,tp)
	return true
end

function c18917000.lvfilter(c,c2)
	return c:IsFaceup() and c:GetLevel()>0 and c:GetLevel()~=c2:GetLevel()
end
function c18917000.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c18917000.lvfilter(chkc,c) end
	if chk==0 then return Duel.IsExistingTarget(c18917000.lvfilter,tp,LOCATION_MZONE,0,1,c,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c18917000.lvfilter,tp,LOCATION_MZONE,0,1,1,c,c)
end
function c18917000.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(tc:GetLevel())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end

function c18917000.ssfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xb00)
		and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c18917000.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c18917000.ssfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c18917000.ssop(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.GetLocationCount(tp,LOCATION_MZONE)>0) then return end
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,c18917000.ssfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

--If both cards in your PZ are Reverse Pendulums, then your opponent's PS is limited.
--0xb00 == reverse pendulum set code
function c18917000.psopcon(e,c)
	local tp=e:GetHandler()
	local scleft=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local scright=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	return scleft and scright and scleft:IsSetCard(0xb00) and scright:IsSetCard(0xb00)
end
function c18917000.psoplimit(e,c,sump,sumtype,sumpos,targetp)
	local lsc=Duel.GetFieldCard(tp,LOCATION_SZONE,6):GetLeftScale()
	local rsc=Duel.GetFieldCard(tp,LOCATION_SZONE,7):GetRightScale()
	if rsc>lsc then
		return (c:GetLevel()>lsc and c:GetLevel()<rsc) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
	else
		return (c:GetLevel()>rsc and c:GetLevel()<lsc) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
	end
end

function c18917000.psactivate(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFieldCard(1-tp,LOCATION_SZONE,6)
	--Note: Do not change the number for the flag effect.
	if tc1 and tc1:GetFlagEffect(77777831)<1 then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_BOTH_SIDE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,10000000)
	e1:SetCondition(c18917000.pendcon)
	e1:SetOperation(c18917000.pendop)
	e1:SetValue(SUMMON_TYPE_PENDULUM)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	tc1:RegisterEffect(e1)
	tc1:RegisterFlagEffect(77777831,RESET_EVENT+0x1fe0000,0,1)
	end
end
function c18917000.spfilter(c)
return c:IsFaceup() and c:IsSetCard(0xb00)
end
function c18917000.pendcon()
	return	function(e,c,ischain,re,rp)
				if c==nil then return true end
				local tp=c:GetControler()
				local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
				if rpz==nil or c==rpz or (not inchain and Duel.GetFlagEffect(tp,10000000)>0) then return false end
				local lscale=c:GetLeftScale()
				local rscale=rpz:GetRightScale()
				local loc=0
				if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
				if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)>0 then loc=loc+LOCATION_EXTRA end
				if loc==0 then return false end
				local g=nil
				if og then
					g=og:Filter(Card.IsLocation,nil,loc)
				else
					g=Duel.GetFieldGroup(tp,loc,0)
				end
				return g:IsExists(c18917000.penFilter,1,nil,e,tp,lscale,rscale,c:IsHasEffect(511007000) and rpz:IsHasEffect(511007000))
			end
end
function c18917000.pendop()
	return	function(e,tp,eg,ep,ev,re,r,rp,c,sg,inchain)
				local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
				local lscale=c:GetLeftScale()
				local rscale=rpz:GetRightScale()
				local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
				local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
				local ft=Duel.GetUsableMZoneCount(tp)
				if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then
					if ft1>0 then ft1=1 end
					if ft2>0 then ft2=1 end
					ft=1
				end
				local loc=0
				if ft1>0 then loc=loc+LOCATION_HAND end
				if ft2>0 then loc=loc+LOCATION_EXTRA end
				local tg=nil
				if og then
					tg=og:Filter(Card.IsLocation,nil,loc):Filter(c18917000.penFilter,nil,e,tp,lscale,rscale,c:IsHasEffect(511007000) and rpz:IsHasEffect(511007000))
				else
					tg=Duel.GetMatchingGroup(c18917000.penFilter,tp,loc,0,nil,e,tp,lscale,rscale,c:IsHasEffect(511007000) and rpz:IsHasEffect(511007000))
				end
				ft1=math.min(ft1,tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND))
				ft2=math.min(ft2,tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA))
				ft2=math.min(ft2,aux.CheckSummonGate(tp) or ft2)
				while true do
					local ct1=tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND)
					local ct2=tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
					local ct=ft
					if ct1>ft1 then ct=math.min(ct,ft1) end
					if ct2>ft2 then ct=math.min(ct,ft2) end
					local loc=0
					if ft1>0 then loc=loc+LOCATION_HAND end
					if ft2>0 then loc=loc+LOCATION_EXTRA end
					local g=tg:Filter(Card.IsLocation,sg,loc)
					if #g==0 or ft==0 then break end
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					local tc=Group.SelectUnselect(g,sg,tp,#sg>0,Duel.IsSummonCancelable())
					if not tc then break end
					if sg:IsContains(tc) then
						sg:RemoveCard(tc)
						if tc:IsLocation(LOCATION_HAND) then
							ft1=ft1+1
						else
							ft2=ft2+1
						end
						ft=ft+1
					else
						sg:AddCard(tc)
						if c:IsHasEffect(511007000)~=nil or rpz:IsHasEffect(511007000)~=nil then
							if not c18917000.penFilter(tc,e,tp,lscale,rscale) then
								local pg=sg:Filter(aux.TRUE,tc)
								local ct0,ct3,ct4=#pg,pg:FilterCount(Card.IsLocation,nil,LOCATION_HAND),pg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
								sg:Sub(pg)
								ft1=ft1+ct3
								ft2=ft2+ct4
								ft=ft+ct0
							else
								local pg=sg:Filter(aux.NOT(c18917000.penFilter),nil,e,tp,lscale,rscale)
								sg:Sub(pg)
								if #pg>0 then
									if pg:GetFirst():IsLocation(LOCATION_HAND) then
										ft1=ft1+1
									else
										ft2=ft2+1
									end
									ft=ft+1
								end
							end
						end
						if tc:IsLocation(LOCATION_HAND) then
							ft1=ft1-1
						else
							ft2=ft2-1
						end
						ft=ft-1
					end
				end
				if #sg>0 then
					if not inchain then
						Duel.RegisterFlagEffect(tp,10000000,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,1)
					end
					Duel.HintSelection(Group.FromCards(c))
					Duel.HintSelection(Group.FromCards(rpz))
				end
			end
end
