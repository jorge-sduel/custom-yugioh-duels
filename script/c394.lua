--over hundred xyz 
function c394.initial_effect(c)
	--[[Activate	
	local e1=Effect.CreateEffect(c)	
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
e1:SetCountLimit(1,394+EFFECT_COUNT_CODE_DUEL)
	e1:SetRange(0x5f)
	e1:SetOperation(print_hand)
	c:RegisterEffect(e1)
	--add card
	local e2=Effect.CreateEffect(c)
e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetDescription(aux.Stringid(215,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_REMOVED)
e2:SetCountLimit(1)
  e2:SetOperation(print_hand)
  c:RegisterEffect(e2)]]
	aux.GlobalCheck(c394,function()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetOperation(c394.op)
		Duel.RegisterEffect(e1,0)
	end )
	aux.EnableExtraRules(c,c394,print_hand)
end
--[[function c394.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
if not Duel.SelectYesNo(1-tp,aux.Stringid(4010,0)) or not Duel.SelectYesNo(tp,aux.Stringid(4010,0)) then
        local sg=Duel.GetMatchingGroup(Card.IsCode,tp,0x7f,0x7f,nil,394)
        Duel.SendtoDeck(sg,nil,-2,REASON_RULE)
        return
    end	
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_REMOVED,0,1,nil,394) then
		Duel.DisableShuffleCheck()
		Duel.SendtoDeck(c,nil,-2,REASON_RULE)
	else
		Duel.Remove(c,POS_FACEUP,REASON_RULE)
		Duel.Hint(HINT_CARD,0,394)
	end
	if c:GetPreviousLocation()==LOCATION_HAND then
		Duel.Draw(tp,1,REASON_RULE)
	end
end]]
function c394.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.DisableShuffleCheck()
	Duel.SendtoDeck(e:GetHandler(),nil,-2,REASON_RULE)
	e:Reset()
end
function print_hand(e,tp,eg,ep,ev,re,r,rp)
	local dg=Group.CreateGroup()
	local dg2=Group.CreateGroup()
	--local n=true
	--local c=Duel.CreateToken(tp,393)
	--if n then
	--Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(394,0))
	--	return
	--end
	--if n then
		--Duel.SendtoHand(e:GetHandler(),nil,REASON_RULE)
		--Duel.Remove(c,POS_FACEUP,REASON_RULE)
	--c394.announce_filter={210220076,210220077,210220078,210220079,469,132,OPCODE_ISCODE}
	--local c1=Duel.AnnounceCard(tp,table.unpack(c394.announce_filter))
		--Duel.SendtoHand(c,1-tp,REASON_RULE)
		--Duel.RegisterFlagEffect(tp,4392470,0,99,99)
	--else
		--Duel.SendtoHand(e:GetHandler(),nil,REASON_RULE)
		--Duel.Remove(c,POS_FACEUP,REASON_RULE)
	local token01=Duel.CreateToken(0,210220076)
	local token02=Duel.CreateToken(0,210220077)
	local token03=Duel.CreateToken(0,210220078)
	local token04=Duel.CreateToken(0,210220079)
	local token05=Duel.CreateToken(0,469)
	local token06=Duel.CreateToken(0,132)
	local token001=Duel.CreateToken(0,210220076)
	local token002=Duel.CreateToken(0,210220077)
	local token003=Duel.CreateToken(0,210220078)
	local token004=Duel.CreateToken(0,210220079)
	local token005=Duel.CreateToken(0,469)
	local token006=Duel.CreateToken(0,132)
	dg:AddCard(token01)
	dg:AddCard(token02)
	dg:AddCard(token03)
	dg:AddCard(token04)
	dg:AddCard(token05)
	dg:AddCard(token06)
	dg2:AddCard(token001)
	dg2:AddCard(token002)
	dg2:AddCard(token003)
	dg2:AddCard(token004)
	dg2:AddCard(token005)
	dg2:AddCard(token006)
	--local c2=Duel.AnnounceCard(1-tp,table.unpack(c394.announce_filter))
	local c1=dg:Select(0,1,1,nil)
	local c2=dg2:Select(1,1,1,nil)
	Duel.SendtoDeck(c1,nil,2,REASON_RULE)
	Duel.SendtoDeck(c2,nil,2,REASON_RULE)
	--end
end
