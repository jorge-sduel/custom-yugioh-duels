--created by Chahine, coded by Lyris
--Conjoint Twister
local cid,id=GetID()
function cid.initial_effect(c)
	--Remove up to 9 E-Cs from 1 Evolute Monster you control, then target 1 Spell/Trap for each 3 E-Cs removed; destroy them.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCost(cid.cost)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.activate)
	c:RegisterEffect(e1)
	--This card can attack directly.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
--hand synchro
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetCode(EFFECT_ADD_TYPE)
	e7:SetValue(TYPE_MONSTER)
	c:RegisterEffect(e7)
--hand synchro
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetCode(16000820)
	c:RegisterEffect(e8)

end
function cid.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cid.cfilter(c,tp)
	return c:IsCanRemoveCounter(tp,0x111f,3,REASON_COST)
end
function cid.filter(c,e)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsCanBeEffectTarget(e)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and cid.filter(chkc,e) and chkc~=e:GetHandler() end
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(cid.cfilter,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.IsExistingTarget(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler(),TYPE_SPELL+TYPE_TRAP)
	end
	Duel.Hint(HINT_SELECTMSG,tp,10)
	local tg=Duel.SelectMatchingCard(tp,cid.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.HintSelection(tg)
	local tc=tg:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,cid.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,math.floor(tc:GetCounter(0x111f)/3),e:GetHandler(),e)
	tc:RemoveCounter(tp,0x111f,3*#g,REASON_COST)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e2)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(g,REASON_EFFECT)
end
