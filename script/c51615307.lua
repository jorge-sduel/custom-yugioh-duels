--created by LeonDuvall, coded by Lyris
local cid,id=GetID()
cid.IsTimeleap=true
if not TIMELEAP_IMPORTED then Duel.LoadScript("proc_timeleap.lua") end
function cid.initial_effect(c)
	c:EnableReviveLimit()
	--time leap procedure
Timeleap.AddProcedure(c,cid.matfilter,1,1,cid.timecon)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCondition(function(e,tp) return e:GetHandler():IsSummonType(SUMMON_TYPE_TIMELEAP) and Duel.GetTurnPlayer()==tp end)
	e1:SetTarget(cid.destg)
	e1:SetOperation(cid.desop)
	c:RegisterEffect(e1)
	--Negate an opponent's card or effect and destroy that card
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	--e2:SetCountLimit(1,id)
	e2:SetCondition(cid.discon)
	e2:SetTarget(cid.distg)
	e2:SetOperation(cid.disop)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetTarget(cid.tglim)
	e4:SetValue(cid.efilter)
	c:RegisterEffect(e4)
end
cid.listed_names={51615301}
cid.material={51615301}
function cid.timecon(e)
	return not Duel.IsExistingMatchingCard(cid.confilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil) 
end
function cid.confilter(c)
	return c:IsFaceup() and c:IsCode(id)
end
function cid.matfilter(c)
	return c:IsCode(id-6)
end
function cid.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and chkc:IsType(TYPE_SPELL+TYPE_TRAP) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP),1,0,0)
	Duel.SetChainLimit(function(ef,rpr) return rpr==tp or not ef:GetHandler():IsType(TYPE_SPELL+TYPE_TRAP) end)
end
function cid.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.Destroy(tc,REASON_EFFECT) end
end
function cid.tglim(e,c)
	return c:IsFaceup() and c:IsSetCard(0xcfd) and not c:IsCode(id)
end
function cid.efilter(e,re,rp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and rp~=e:GetHandlerPlayer()
end
function cid.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsBattlePhase() and ep==1-tp and Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,e:GetHandler())
		and Duel.IsChainDisablable(ev) and e:GetHandler():IsSummonType(SUMMON_TYPE_TIMELEAP2)
end
function cid.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	local rc=re:GetHandler()
	if rc:IsDestructable() and rc:IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cid.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
