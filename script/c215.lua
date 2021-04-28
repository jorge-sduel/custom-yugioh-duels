--over hundred xyz 
function c215.initial_effect(c)
	--Activate	
	local e1=Effect.CreateEffect(c)	
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetRange(0x5f)
	e1:SetOperation(c215.op)
	c:RegisterEffect(e1)
	--add card
	local e2=Effect.CreateEffect(c)
e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetDescription(aux.Stringid(215,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_REMOVED)
e2:SetCountLimit(1,215+EFFECT_COUNT_CODE_DUEL)
  e2:SetOperation(print_hand)
  c:RegisterEffect(e2)
end
function c215.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
if not Duel.SelectYesNo(1-tp,aux.Stringid(4010,0)) or not Duel.SelectYesNo(tp,aux.Stringid(4010,0)) then
        local sg=Duel.GetMatchingGroup(Card.IsCode,tp,0x7f,0x7f,nil,215)
        Duel.SendtoDeck(sg,nil,-2,REASON_RULE)
        return
    end	
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_REMOVED,0,1,nil,215) then
		Duel.DisableShuffleCheck()
		Duel.SendtoDeck(c,nil,-2,REASON_RULE)
	else
		Duel.Remove(c,POS_FACEUP,REASON_RULE)
		Duel.Hint(HINT_CARD,0,215)
	end
	if c:GetPreviousLocation()==LOCATION_HAND then
		Duel.Draw(tp,1,REASON_RULE)
	end
end
function print_hand(e,tp,eg,ep,ev,re,r,rp)
	local n=true
	local ac={217,218,216}
	local c=Duel.CreateToken(tp,48739166)
	local tc=Duel.CreateToken(tp,12744567)
	local sc=Duel.CreateToken(tp,49678559)
	local gc=Duel.CreateToken(tp,67173574)
	local lc=Duel.CreateToken(tp,94380860)
	local hc=Duel.CreateToken(tp,20785975)
	local jc=Duel.CreateToken(tp,2061963)
	local kc=Duel.CreateToken(tp,49456901)
	local pc=Duel.CreateToken(tp,59627393)
	local yc=Duel.CreateToken(tp,85121942)
	local qc=Duel.CreateToken(tp,63746411)
	local wc=Duel.CreateToken(tp,55888045)
	local dc=Duel.CreateToken(tp,88177324)
	local rc=Duel.CreateToken(tp,68396121)
	if n and (c:IsSetCard(0x2fff) or c:IsCode(99004583) or c:IsCode(35498188)) then
		Debug.Message("只能添加怪兽卡到手卡")
		return
	end
	if n then
		Duel.SendtoHand(c,nil,REASON_RULE)
		Duel.SendtoHand(tc,nil,REASON_RULE)
		Duel.SendtoHand(sc,nil,REASON_RULE)
		Duel.SendtoHand(gc,nil,REASON_RULE)
		Duel.SendtoHand(lc,nil,REASON_RULE)
		Duel.SendtoHand(hc,nil,REASON_RULE)
		Duel.SendtoHand(jc,nil,REASON_RULE)
		Duel.SendtoHand(kc,nil,REASON_RULE)
		Duel.SendtoHand(pc,nil,REASON_RULE)
		Duel.SendtoHand(yc,nil,REASON_RULE)
		Duel.SendtoHand(qc,nil,REASON_RULE)
		Duel.SendtoHand(wc,nil,REASON_RULE)
		Duel.SendtoHand(dc,nil,REASON_RULE)
		Duel.SendtoHand(rc,nil,REASON_RULE)
		Duel.RegisterFlagEffect(tp,4392470,0,99,99)
	else
		Duel.SendtoHand(c,nil,REASON_RULE)
		Duel.SendtoHand(tc,nil,REASON_RULE)
		Duel.SendtoHand(sc,nil,REASON_RULE)
		Duel.SendtoHand(gc,nil,REASON_RULE)
		Duel.SendtoHand(lc,nil,REASON_RULE)
		Duel.SendtoHand(hc,nil,REASON_RULE)
		Duel.SendtoHand(jc,nil,REASON_RULE)
		Duel.SendtoHand(kc,nil,REASON_RULE)
		Duel.SendtoHand(pc,nil,REASON_RULE)
		Duel.SendtoHand(yc,nil,REASON_RULE)
		Duel.SendtoHand(qc,nil,REASON_RULE)
		Duel.SendtoHand(wc,nil,REASON_RULE)
		Duel.SendtoHand(dc,nil,REASON_RULE)
		Duel.SendtoHand(rc,nil,REASON_RULE)
	end
end