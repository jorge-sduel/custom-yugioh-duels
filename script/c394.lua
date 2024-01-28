--over hundred xyz 
function c394.initial_effect(c)
	--Activate	
	local e1=Effect.CreateEffect(c)	
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
e1:SetCountLimit(1,394+EFFECT_COUNT_CODE_DUEL)
	e1:SetRange(0x5f)
	e1:SetOperation(c394.op)
	c:RegisterEffect(e1)
	--add card
	local e2=Effect.CreateEffect(c)
e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetDescription(aux.Stringid(215,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_REMOVED)
e2:SetCountLimit(1)
  e2:SetOperation(print_hand)
  c:RegisterEffect(e2)
end
function c394.op(e,tp,eg,ep,ev,re,r,rp,chk)
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
end
function print_hand(e,tp,eg,ep,ev,re,r,rp)
	local n=true
	--local c=Duel.CreateToken(tp,393)
	--if n then
	--Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(394,0))
	--	return
	--end
	if n then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_RULE)
		--Duel.Remove(c,POS_FACEUP,REASON_RULE)
	c394.announce_filter={210220076,210220077,210220078,210220079,469,132,OPCODE_ISCODE}
	--local c1=Duel.AnnounceCard(tp,table.unpack(c394.announce_filter))
		Duel.SendtoHand(c,1-tp,REASON_RULE)
		Duel.RegisterFlagEffect(tp,4392470,0,99,99)
	else
		Duel.SendtoHand(e:GetHandler(),nil,REASON_RULE)
		Duel.Remove(c,POS_FACEUP,REASON_RULE)
	local token01=Duel.CreateToken(tp,210220076)
	local token02=Duel.CreateToken(tp,210220077)
	local token03=Duel.CreateToken(tp,210220078)
	local token04=Duel.CreateToken(tp,210220079)
	local token05=Duel.CreateToken(tp,469)
	local token06=Duel.CreateToken(tp,132)
	local token001=Duel.CreateToken(tp,210220076)
	local token002=Duel.CreateToken(tp,210220077)
	local token003=Duel.CreateToken(tp,210220078)
	local token004=Duel.CreateToken(tp,210220079)
	local token005=Duel.CreateToken(tp,469)
	local token006=Duel.CreateToken(tp,132)
		c394.announce_filter={395,OPCODE_ISCODE}
	--local c2=Duel.AnnounceCard(1-tp,table.unpack(c394.announce_filter))
	local c1=token01+token02+token03+token03+token04+token05+token06:Select(tp,1,1,nil)
	local c2=token001+token002+token003+token003+token004+token005+token006:Select(tp,1,1,nil)
	Duel.SendtoHand(c1,tp,REASON_RULE)
	Duel.SendtoHand(c2,1-tp,REASON_RULE)
	end
end
