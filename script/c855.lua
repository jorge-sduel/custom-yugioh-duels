--Gate of Star-vader
function c855.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Special Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(855,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c855.sptg)
	e2:SetOperation(c855.spop)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(855,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e3:SetCode(EVENT_REMOVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c855.dmcon)
	e3:SetTarget(c855.dmtg)
	e3:SetOperation(c855.dmop)
	c:RegisterEffect(e3)
	--Drive Check
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(855,2))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c855.con)
	e4:SetTarget(c855.target)
	e4:SetOperation(c855.activate)
	c:RegisterEffect(e4)
	--Twin Drive
	local e5=e4:Clone()
	e5:SetDescription(aux.Stringid(855,3))
	e5:SetCondition(c855.con2)
	c:RegisterEffect(e5)
end
function c855.spfilter(c,e,tp)
	return c:IsSetCard(0x5DC) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c855.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c855.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c855.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.GetMatchingGroup(c855.spfilter,tp,LOCATION_DECK,0,nil,e,tp):RandomSelect(tp,1)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c855.dmfilter(c,tp)
	return c:IsControler(1-tp) and c:IsFacedown()
end
function c855.dmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c855.dmfilter,1,nil,tp)
end
function c855.dmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
function c855.dmop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c855.con(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	return (tc:IsSetCard(0x5DC) or tc:IsSetCard(0x5AA)) and tc:IsControler(e:GetHandlerPlayer())
end
function c855.con2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	return (tc:IsSetCard(0x5DC) or tc:IsSetCard(0x5AA)) and tc:IsControler(e:GetHandlerPlayer()) and Duel.IsExistingMatchingCard(c855.cfilter,tc:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c855.cfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x5DC) or c:IsSetCard(0x5AA)) and c:GetAttack()>=3000
end
function c855.filter(c)
	return c:IsAbleToHand()
end
function c855.filter2(c)
	return c:IsSetCard(0x5DC) and c:IsType(TYPE_MONSTER)
end
function c855.filter3(c)
	return (c:IsSetCard(0x5DC) or c:IsSetCard(0x5AA)) and c:IsType(TYPE_MONSTER)
end
function c855.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<1 then return false end
		local g=Duel.GetDecktopGroup(tp,1)
		local result=g:FilterCount(c855.filter,nil)>0
		return result
	end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function c855.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.ConfirmDecktop(p,1)
	local g=Duel.GetDecktopGroup(p,1)
	Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
	local sg=g:FilterSelect(p,c855.filter,1,1,nil)
		if sg:GetFirst():IsAbleToHand() then
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-p,sg)
		end
	if g:IsExists(c855.filter2,1,nil) then
	local tg=Duel.SelectTarget(p,c855.filter3,p,LOCATION_MZONE,0,1,1,nil)
	local tc1=tg:GetFirst()
	if tc1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(500)
		tc1:RegisterEffect(e1)
	local dr=Duel.IsExistingMatchingCard(c855.drfilter,p,LOCATION_SZONE,0,1,nil)
	if dr and Duel.IsPlayerCanDraw(p,1) and Duel.GetFlagEffect(p,856)==0 then
		if Duel.SelectYesNo(p,aux.Stringid(856,0)) then
		Duel.Draw(p,1,REASON_EFFECT)
		Duel.RegisterFlagEffect(p,856,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
		end
	end
	local at=Duel.IsExistingMatchingCard(c855.atfilter,p,LOCATION_SZONE,0,1,nil)
	if at and Duel.GetFlagEffect(p,857)==0 then
		if Duel.SelectYesNo(p,aux.Stringid(857,0)) then
		local ag=Duel.SelectTarget(p,c855.filter3,p,LOCATION_MZONE,0,1,1,nil)
		local tc2=ag:GetFirst()
		if tc2 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		tc2:RegisterEffect(e1)
		end
		end
		Duel.RegisterFlagEffect(p,857,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
	end
	end
	end	
end
function c855.drfilter(c)
	return c:IsCode(856) and not c:IsDisabled()
end
function c855.atfilter(c)
	return c:IsCode(857) and not c:IsDisabled()
end