--Sunfire Dragon
function c87624276.initial_effect(c)

	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(87624276,3))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c87624276.ntcon)
	e1:SetOperation(c87624276.ntop)
	c:RegisterEffect(e1)
	
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(87624276,2))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c87624276.dmgcon)
	e2:SetTarget(c87624276.dmgtg)
	e2:SetOperation(c87624276.dmgop)
	c:RegisterEffect(e2)
	
	--reveal
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(87624276,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_REMOVED)
	e3:SetCondition(c87624276.revcon)
	e3:SetCost(c87624276.revcost)
	e3:SetTarget(c87624276.revtg)
	e3:SetOperation(c87624276.revop)
	c:RegisterEffect(e3)
end
--Summon with no tribute condition
function c87624276.ntcon(e,c)
	if c==nil then return true end
	return c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
--Summon with no tribute operation
function c87624276.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	--change base attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+0xff0000)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(1800)
	c:RegisterEffect(e1)
end
--Damage condition
function c87624276.dmgcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
--Damage target
function c87624276.dmgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,500)
end
--Damage operation
function c87624276.dmgop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
--Reveal condition
function c87624276.revcon(e,c)
	return e:GetHandler():IsFaceup()
end
--Reveal cost filter
function c87624276.revfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
--Reveal cost
function c87624276.revcost(e,tp,eg,ep,ev,re,r,rp,chk)local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c87624276.revfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c87624276.revfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
--Reveal target
function c87624276.revtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,87624276)==0 and Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.RegisterFlagEffect(tp,87624276,0,0,0)
end
--Reveal operation
function c87624276.revop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
	Duel.ConfirmCards(tp,sg)
end