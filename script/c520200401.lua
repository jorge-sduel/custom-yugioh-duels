--Master Rules 2020 Revision
function c520200401.initial_effect(c)
	--Activate	
	local e1=Effect.CreateEffect(c)	
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetRange(0x5f)
	e1:SetOperation(c520200401.op)
	c:RegisterEffect(e1)
	--decrease tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72497366,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetTargetRange(LOCATION_EXTRA,LOCATION_EXTRA)
	e2:SetTarget(c520200401.Lool)
	e2:SetOperation(c520200401.CheckBool)
	c:RegisterEffect(e2)
end
function c520200401.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
if not Duel.SelectYesNo(1-tp,aux.Stringid(4010,0)) or not Duel.SelectYesNo(tp,aux.Stringid(4010,0)) then
        local sg=Duel.GetMatchingGroup(Card.IsCode,tp,0x7f,0x7f,nil,520200401)
        Duel.SendtoDeck(sg,nil,-2,REASON_RULE)
        return
    end	
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_REMOVED,0,1,nil,520200401) then
		Duel.DisableShuffleCheck()
		Duel.SendtoDeck(c,nil,-2,REASON_RULE)
	else
		Duel.Remove(c,POS_FACEUP,REASON_RULE)
		Duel.Hint(HINT_CARD,0,520200401)
	end
	if c:GetPreviousLocation()==LOCATION_HAND then
		Duel.Draw(tp,1,REASON_RULE)
	end
end
function c520200401.Lool(e,tp,eg,ep,ev,re,r,rp,sg)
				local pos=pos or POS_FACEUP
				local summonp=math.abs(sump-tp)
				local targettp=math.abs(targetp-tp)
				then
					local cardtable={}
					local cc=sg:GetFirst()
					while cc do
						table.insert(cardtable,cc)
						cc=sg:GetNext()
					end
					local cardtableclone={table.unpack(cardtable)}
					local mmz=mmz
					if not mmz then
						mmz=0
						for i=0,4 do
							if Duel.GetLocationCount(targettp,LOCATION_MZONE,targettp,LOCATION_REASON_TOFIELD,0x1<<i)>0 then
								mmz=mmz|(0x1<<i)
							end
						end
					end
					if mmz<=0 then return false end
					local emz=emz
					if not emz then
						emz=Duel.GetLinkedZone(tp)
						if Duel.CheckLocation(targettp,LOCATION_MZONE,5) then
							emz=emz|0x20
						end
						if Duel.CheckLocation(targettp,LOCATION_MZONE,6) then
							emz=emz|0x40
						end
					end
					for _,tc in ipairs(cardtableclone) do
						table.remove(cardtable,1)
						local zone=c520200401.SummonZones(tc,mmz,emz,e,sumtype,summonp,targettp,nocheck,nolimit,pos,table.unpack(cardtable))
						if zone==0 then return false end
						if not Duel.SpecialSummonStep(tc,sumtype,summonp,targettp,nocheck,nolimit,pos,zone) then return false end
						emz=emz&~(0x1<<tc:GetSequence())
						mmz=mmz&~(0x1<<tc:GetSequence())
						if func then
							func(e,tp,eg,ep,ev,re,r,rp,tc)
						end
					end
					Duel.SpecialSummonComplete()
					return true,sg
				else
					local mmz=mmz
					if not mmz then
						mmz=0x1f
					end
					local emz=emz
					if not emz then
						emz=0x1f
					end
					local tc=sg:GetFirst()
					while tc do
						local zone=tc:IsLocation(LOCATION_EXTRA) and emz or mmz
						if not (tc:IsType(TYPE_LINK) or (tc:IsType(TYPE_PENDULUM) and tc:IsPosition(POS_FACEUP))) then
							zone=emz|mmz
						end
						if not Duel.SpecialSummonStep(tc,sumtype,summonp,targettp,nocheck,nolimit,pos,zone) then return false end
						if func then
							func(e,tp,eg,ep,ev,re,r,rp,tc)
						end
						tc=sg:GetNext()
					end
					Duel.SpecialSummonComplete()
					return true,sg
				end
			end
end