--
--Timelord Progenitor
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Synchro Summon Procedure
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(s.matfilter),1,99)
	--Cannot be destroyed battle or effects
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--No battle bamage from attacks involving this card
	local e3=e1:Clone()
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e3)
	--direct attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e4)
	--Must be special summoned by its own method
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e5)
	--Special summon procedure (from extra deck)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_SPSUMMON_PROC)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e6:SetRange(LOCATION_EXTRA)
	e6:SetCondition(s.sprcon)
	e6:SetOperation(s.disop)
	c:RegisterEffect(e6)
	--ATK Up
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetValue(s.val)
	c:RegisterEffect(e7)
	-- Inflict Damage
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(id,0))
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e8:SetCode(EVENT_LEAVE_FIELD)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTarget(s.damtg)
	e8:SetOperation(s.damop)
	c:RegisterEffect(e8)
end
s.listed_series={0x4a}
function s.matfilter(c)
	return c:IsType(TYPE_SYNCHRO) 
end

function s.discfilter(c)
	return c:IsMonster() and c:IsSetCard(0x4a) and c:IsAbleToRemoveAsCost()
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(s.discfilter,tp,LOCATION_GRAVE,0,3,nil)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.discfilter,tp,LOCATION_GRAVE,0,3,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.discfilter,tp,LOCATION_GRAVE,0,3,3,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.val(e,c)
	return Duel.GetMatchingGroup(Card.IsType,c:GetControler(),0,LOCATION_MZONE,nil,TYPE_MONSTER):GetSum(Card.GetAttack)
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=Duel.GetFieldGroupCount(tp,0xc,0xc)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetFieldGroupCount(tp,0xc,0xc)
	Duel.SetLP(1-tp,Duel.GetLP(1-tp)-ct*300)
end
