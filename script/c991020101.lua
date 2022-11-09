--Hamon Lord of Vengeful Storm
local s,id=GetID()
s.Is_Runic=true
if not RUNIC_IMPORTED then Duel.LoadScript("proc_runic.lua") end
function s.initial_effect(c)
	--rune procedure
	c:EnableReviveLimit()
	aux.AddRunicState(c)
	local r1=Effect.CreateEffect(c)
	r1:SetType(EFFECT_TYPE_FIELD)
	r1:SetCode(EFFECT_SPSUMMON_PROC)
	r1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	r1:SetRange(LOCATION_HAND)
	r1:SetCondition(s.runcon)
	r1:SetOperation(s.runop)
	r1:SetValue(SUMMON_TYPE_RUNIC)
	c:RegisterEffect(r1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--inflict damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98162242,0))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.damtg)
	e3:SetOperation(s.damop)
	c:RegisterEffect(e3)
	--Protect other Monsters
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	--e4:SetCondition(s.protectcon)
	e4:SetTarget(s.protecttg)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--Damage 0 for the rest of Turn
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(s.nodmgcon)
	e5:SetOperation(s.nodmgop)
	c:RegisterEffect(e5)
	--damage
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,0))
	e6:SetCategory(CATEGORY_DAMAGE)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EVENT_BATTLE_DESTROYING)
	e6:SetCondition(s.damcon1)
	e6:SetTarget(s.damtg1)
	e6:SetOperation(s.damop1)
	c:RegisterEffect(e6)
end
function s.matfilter1(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_MZONE)
end
function s.matfilter2(c)
	return c:IsType(TYPE_SPELL)
end
function s.runfilter1(c)
	return s.matfilter2(c) and Duel.IsExistingMatchingCard(s.matfilter1,c:GetControler(),LOCATION_MZONE,0,1,c)
end
function s.runcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1 and Duel.IsExistingMatchingCard(s.runfilter1,c:GetControler(),LOCATION_ONFIELD,0,2,nil)
end
function s.runop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Group.CreateGroup()
	local g2=Duel.GetMatchingGroup(s.matfilter1,tp,LOCATION_MZONE,0,nil,c)
	local mt1=Duel.SelectMatchingCard(tp,s.runfilter1,c:GetControler(),LOCATION_ONFIELD,0,1,99,nil,c)
	g:Merge(mt1)
	g2:Sub(mt1)
	local mt2=g2:Select(tp,1,1,nil)
	g:Merge(mt2)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_RUNIC)
end
function s.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsReason(REASON_BATTLE) and bc:IsType(TYPE_MONSTER)
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=e:GetHandler():GetMaterial():FilterCount(Card.IsType,nil,TYPE_SPELL)
	local dam=ct*500
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function s.protecttg(e,c)
	return c~=e:GetHandler()
end
function s.nodmgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function s.nodmgop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e3:SetDescription(aux.Stringid(4016,2))
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetTargetRange(1,0)
	Duel.RegisterEffect(e3,tp)
end
function s.damcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsMonster()
end
function s.damtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetHandler():GetBattleTarget()
	Duel.SetTargetCard(bc)
	local dam=bc:GetAttack()
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function s.damop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local dam=tc:GetAttack()
		if dam<0 then dam=0 end
		Duel.Damage(p,dam,REASON_EFFECT)
	end
end
