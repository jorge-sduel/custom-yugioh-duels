--Guardian of the Immortal Runic Hall
c964382790.Is_Runic=true
if not RUNIC_IMPORTED then Duel.LoadScript("proc_runic.lua") end
function c964382790.initial_effect(c)
	--Rune Summon
	c:EnableReviveLimit()
	Runic.AddProcedure(c,nil,c964382790.STMatFilter,2,2,LOCATION_DECK)
	aux.AddRunicProcedure2(c,aux.FilterBoolFunction(Card.IsCode,946320791),c964382790.STMatFilter,2,2,LOCATION_DECK)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(24294108,0))
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetTarget(c964382790.settg)
	e1:SetOperation(c964382790.setop)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1801154,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c964382790.reccon)
	e2:SetTarget(c964382790.rectg)
	e2:SetOperation(c964382790.recop)
	c:RegisterEffect(e2)
end
function c964382790.STMatFilter(c)
	return c:GetOriginalType()==0x2 or c:GetOriginalType()==0x4
end
function c964382790.setfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup() and c:IsCanTurnSet()
end
function c964382790.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c964382790.setfilter,e:GetHandler():GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
function c964382790.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c964382790.setfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if c:IsRelateToEffect(e) and g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEDOWN)
	end
end
function c964382790.recfilter(c,r,rp,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and bit.band(r,0x41)==0x41 and rp~=tp
		and c:IsPreviousPosition(POS_FACEDOWN)
end
function c964382790.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c964382790.recfilter,1,nil,r,rp,e:GetHandlerPlayer())
end
function c964382790.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c964382790.recop(e,tp,eg,ep,ev,re,r,rp)
	local rt=eg:FilterCount(c964382790.recfilter,nil,r,rp,e:GetHandler():GetControler())*500
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,rt,REASON_EFFECT)
end
