--External Worlds Dark Synchro Dragon
--Scripted by Secuter
function c12340025.initial_effect(c)
	--dark synchro summon 
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c12340025.syncon)
	--e1:SetTarget(c12340025.syntg)
	e1:SetOperation(c12340025.synop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--remove & boost atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340025,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c12340025.rmcond)
	e2:SetTarget(c12340025.rmcost)
	e2:SetOperation(c12340025.rmop)
	c:RegisterEffect(e2)
    --negate effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetOperation(c12340025.disop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_BE_BATTLE_TARGET)
	c:RegisterEffect(e5)
	--change level
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c12340025.lvcon)
	e3:SetValue(12)
	c:RegisterEffect(e3)
end

function c12340025.costfilter(c)
	return c:IsSetCard(0x201) and c:IsAbleToRemoveAsCost() and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c12340025.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12340025.costfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c12340025.costfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c12340025.op(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local atks=c:GetFlagEffect(12340025)*1 +1
    c:RegisterFlagEffect(12340025,RESET_EVENT+0x1ec0000+RESET_PHASE+PHASE_BATTLE,0,atks)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	e1:SetValue(atks)
	c:RegisterEffect(e1)
end

function c12340025.rmcond(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c12340025.rmfilter(c)
	return c:IsSetCard(0x201) and c:IsAbleToRemoveAsCost() and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c12340025.rmcost(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_EXTRA) and chkc:IsControler(1-tp) and c12340025.rmfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12340025.rmfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c12340025.rmfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,99,nil)
	e:SetLabel(g:GetCount())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c12340025.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel()*500)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end

function c12340025.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE_STEP)
		bc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE_STEP)
		bc:RegisterEffect(e2)
	end
end

function c12340025.lvfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsType(TYPE_SYNCHRO)
end
function c12340025.lvcon(e)
	return Duel.IsExistingMatchingCard(c12340025.lvfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end

function c12340025.tmatfilter(c,sc)
	return c:IsSetCard(0x301) and c:IsType(TYPE_TUNER) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsCanBeSynchroMaterial(sc)
end
function c12340025.ntmatfilter(c,sc,tp)
	return c:IsSetCard(0x201) and c:IsNotTuner(sc,tp) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsCanBeSynchroMaterial(sc)
end
function c12340025.synfilter1(c,lv,tuner,sc,pe,tc)
	if sc:GetFlagEffect(100000147)==0 then
		return tuner:IsExists(c12340025.synfilter2,1,c,true,lv,c,sc,pe,tc)
	else
		return tuner:IsExists(c12340025.synfilter2,1,c,false,lv,c,sc,pe,tc)
	end
end
function c12340025.synfilter2(c,add,lv,ntng,sc,pe,tc)    
	if pe and not Group.FromCards(ntng,c):IsContains(pe:GetOwner()) then return false end
	if tc and not Group.FromCards(ntng,c):IsContains(tc) then return false end
	if c.tuner_filter and not c.tuner_filter(ntng) then return false end
	if ntng.tuner_filter and not ntng.tuner_filter(c) then return false end
	if not c:IsHasEffect(EFFECT_HAND_SYNCHRO) and ntng:IsLocation(LOCATION_HAND) then return false end
	if not ntng:IsHasEffect(EFFECT_HAND_SYNCHRO) and c:IsLocation(LOCATION_HAND) then return false end
	if (ntng:IsHasEffect(EFFECT_HAND_SYNCHRO) or c:IsHasEffect(EFFECT_HAND_SYNCHRO)) and c:IsLocation(LOCATION_HAND) 
		and ntng:IsLocation(LOCATION_HAND) then return false end
        
    local tp=sc:GetControler()
	if sc:IsLocation(LOCATION_EXTRA) then
        local sg=Group.CreateGroup()
        sg:AddCard(ntng)
        sg:AddCard(c)
		if Duel.GetLocationCountFromEx(tp,tp,sg,sc)<=0 then return false end
	else
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
            and not Group.FromCards(ntng,c):IsExists(Card.IsLocation,1,nil,LOCATION_MZONE) then return false end
	end
    
	local ntlv=ntng:GetSynchroLevel(sc)
	local lv1=bit.band(ntlv,0xffff)
	local lv2=bit.rshift(ntlv,16)
	if add then
		return c:GetSynchroLevel(sc)==lv+lv1 or c:GetSynchroLevel(sc)==lv+lv2
	else
		return c:GetSynchroLevel(sc)==lv-lv1 or c:GetSynchroLevel(sc)==lv-lv2
	end
end
function c12340025.syncon(e,c,tuner,mg)
	if c==nil then return true end
    local lvsyn=e:GetHandler():GetLevel()
	local tp=c:GetControler()
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local tng=Duel.GetMatchingGroup(c12340025.tmatfilter,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	local ntng=Duel.GetMatchingGroup(c12340025.ntmatfilter,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c,tp)    
	return ntng:IsExists(c12340025.synfilter1,1,nil,lvsyn,tng,c,pe,tuner)
end
function c12340025.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner,mg)
    local lvsyn=e:GetHandler():GetLevel()
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local g=Group.CreateGroup()
	local tun=Duel.GetMatchingGroup(c12340025.tmatfilter,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	local nont=Duel.GetMatchingGroup(c12340025.ntmatfilter,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local nontmat=nont:FilterSelect(tp,c12340025.synfilter1,1,1,nil,lvsyn,tun,c,pe,tuner)
	local mat1=nontmat:GetFirst()
	g:AddCard(mat1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local t
	if mat1:GetFlagEffect(100000147)==0 then
		t=tun:FilterSelect(tp,c12340025.synfilter2,1,1,mat1,true,lvsyn,mat1,c,pe,tuner)
	else
		t=tun:FilterSelect(tp,c12340025.synfilter2,1,1,mat1,false,lvsyn,mat1,c,pe,tuner)
	end
	g:Merge(t)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
end