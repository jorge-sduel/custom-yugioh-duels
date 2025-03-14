--Medivatale Tortoise
c16000820.IsEquilibrium=true
if not EQUILIBRIUM_IMPORTED then Duel.LoadScript("proc_equilibrium.lua") end
function c16000820.initial_effect(c)
	--
	Equilibrium.AddProcedure(c)
--If this card is activated: You can add 1 "Medivatale" card from your Deck or GY to your hand. You can destroy this card, and if you do, all Evolute Monsters you control gain 4 E-C. You can only use each effect of "Medivatale Tortoise" once per turn.
 local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetDescription(aux.Stringid(16000820,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,16000820)
	e1:SetCost(c16000820.cost)
	e1:SetTarget(c16000820.target)
	e1:SetOperation(c16000820.activate)
	c:RegisterEffect(e1) 
	  --Evolute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16000820,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,16000821)
	e2:SetTarget(c16000820.thtg)
	e2:SetOperation(c16000820.thop)
	c:RegisterEffect(e2)
--special summon
--  local e3=Effect.CreateEffect(c)
--  e3:SetDescription(aux.Stringid(16000820,2))
--  e3:SetType(EFFECT_TYPE_FIELD)
--  e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
--  e3:SetCode(EFFECT_SPSUMMON_PROC)
--  e3:SetRange(LOCATION_HAND)
--  e3:SetCountLimit(1,16000822)
--  e3:SetCondition(c16000820.sprcon)
--  c:RegisterEffect(e3) 
	--  local e4=e3:Clone()
--  e4:SetCondition(c16000820.sprcon2)
	--c:RegisterEffect(e4)
	 --become material
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCode(EVENT_BE_MATERIAL)
	e6:SetCondition(c16000820.condition2)
	e6:SetOperation(c16000820.operation2)
	c:RegisterEffect(e6)
--destroy
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(97268402,0))
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_HAND)
	e7:SetTarget(c16000820.destarget)
	e7:SetOperation(Equilibrium.desop1)
	c:RegisterEffect(e7)
--hand synchro
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetCode(16000820)
	e8:SetRange(LOCATION_HAND)
	--e8:SetTarget(c16000820.synchktg)
	--e8:SetCode(EFFECT_HAND_SYNCHRO)
	--e8:SetLabel(16000820)
	--e8:SetValue(c16000820.synval)
	c:RegisterEffect(e8)
end
function c16000820.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c16000820.filter(c)
	return c:IsSetCard(0xab5) and c:IsAbleToHand()
end
function c16000820.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return e:GetHandler():GetFlagEffect(16000820)==0 and Duel.IsExistingMatchingCard(c16000820.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	c:RegisterFlagEffect(16000820,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c16000820.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c16000820.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c16000820.xfilter(c)
	return c.Is_Evolute and c:IsFaceup() 
end

function c16000820.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() and Duel.IsExistingMatchingCard(c16000820.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end

function c16000820.thop(e,tp,eg,ep,ev,re,r,rp)
 local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	local g=Duel.GetMatchingGroup(c16000820.xfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
	 
   tc:AddCounter(0x111f,4)
		tc=g:GetNext()
	end
end
function c16000820.cfilter(c)
	return c:IsFaceup() and ( c:GetSummonLocation()==LOCATION_EXTRA  and c:IsType(TYPE_EFFECT))
end
function c16000820.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and  not Duel.IsExistingMatchingCard(c16000820.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c16000820.cfilter2(c)
	return c:IsFaceup() and c:GetSummonLocation()==LOCATION_EXTRA and  c:IsSetCard(0xab5)
end
function c16000820.sprcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and  Duel.IsExistingMatchingCard(c16000820.cfilter2,tp,LOCATION_MZONE,0,1,nil)
end
function c16000820.matcon(c,ec,mode)
	if mode==1 then return Duel.GetFlagEffect(c:GetControler(),16000820)==0 and c:IsLocation(LOCATION_HAND) end
	return true
end
function c16000820.mfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0xab5)
end
function c16000820.matval(e,c,mg)
	return  mg:IsExists(c16000820.mfilter,1,nil)
end
function c16000820.matop(c)
	Duel.SendtoGrave(c,REASON_MATERIAL+0x10000000)
end
function c16000820.ffilter(c)
	return c:IsRace(RACE_FAIRY)
end

function c16000820.condition2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	return r==REASON_SPSUMMON and rc.Is_Evolute
end
function c16000820.operation2(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetFlagEffect(tp,16000820)~=0 then return end
	Duel.Hint(HINT_CARD,0,16000820) 
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetDescription(aux.Stringid(16000820,3))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetRange(LOCATION_MZONE)
   e1:SetCondition(c16000820.spcon)
	e1:SetTarget(c16000820.sptg)
	e1:SetOperation(c16000820.spop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_ADD_TYPE)
		e0:SetValue(TYPE_EFFECT)
		e0:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e0,true)
	rc:RegisterFlagEffect(16000820,RESET_EVENT+RESETS_STANDARD+0x47e0000,0,1)
	end
	rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(16000820,3))
	Duel.RegisterFlagEffect(tp,16000820,RESET_PHASE+PHASE_END,0,1)
end
function c16000820.cfilter2(c,tp,zone)
return c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and bit.band(c:GetPreviousRaceOnField(),RACE_FAIRY)~=0
		and  (c:IsReason(REASON_BATTLE) or (rp~=tp and c:IsReason(REASON_EFFECT)))
end
function c16000820.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c16000820.cfilter2,1,nil,tp,rp)
end
function c16000820.spfilter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c16000820.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c16000820.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c16000820.spop(e,tp,eg,ep,ev,re,r,rp)
	 local c=e:GetHandler()
	   local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(c16000820.spfilter,tp,LOCATION_HAND,0,nil,e,tp)
	if ft<1 or g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,sg:GetFirst():GetCode())
	if ft>1 and g:GetCount()>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.SelectYesNo(tp,aux.Stringid(16000820,4)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=g:Select(tp,1,1,nil)
		sg:AddCard(sg2:GetFirst())
	end
	if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) then
		c:RemoveCounter(tp,0x111f,2,REASON_EFFECT)
	end
end
function c16000820.destarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and c16000820.desfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c16000820.desfilter,tp,LOCATION_PZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c16000820.desfilter,tp,LOCATION_PZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c16000820.chk2(c)
	if not c:IsHasEffect(EFFECT_HAND_SYNCHRO) or c:IsHasEffect(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK) then return false end
	local te={c:GetCardEffect(EFFECT_HAND_SYNCHRO)}
	for i=1,#te do
		local e=te[i]
		if e:GetLabel()==16000820 then return true end
	end
	return false
end
function c16000820.synchktg(e,c,sg,tg,ntg,tsg,ntsg)
	if c then
		local res=tg:IsExists(c16000820.chk2,1,c) or ntg:IsExists(c16000820.chk2,1,c) or sg:IsExists(c16000820.chk2,1,c)
		return res,Group.CreateGroup(),Group.CreateGroup()
	else
		return true
	end
end
function c16000820.synval(e,c,sc)
	if c:IsLocation(LOCATION_HAND) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_HAND_SYNCHRO+EFFECT_SYNCHRO_CHECK)
		e1:SetLabel(16000820)
		e1:SetTarget(c16000820.synchktg)
		c:RegisterEffect(e1)
		return true
	else return false end
end
