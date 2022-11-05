--Serpent of Immortal Runic Forests
c984379021.Is_Runic=true
if not RUNIC_IMPORTED then Duel.LoadScript("proc_runic.lua") end
function c984379021.initial_effect(c)
	--Rune Summon
	c:EnableReviveLimit()
	Runic.AddProcedure(c,nil,c984379021.STMatFilter,2,2)
	aux.AddRunicProcedure2(c,aux.FilterBoolFunction(Card.IsCode,962438790),c984379021.STMatFilter,2,2,LOCATION_DECK)
	--cannot disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTarget(c984379021.distarget)
	c:RegisterEffect(e1)
	--inactivatable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c984379021.effectfilter)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISEFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c984379021.effectfilter)
	c:RegisterEffect(e3)
	--recover
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1801154,0))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c984379021.damcon)
	e4:SetTarget(c984379021.damtg)
	e4:SetOperation(c984379021.damop)
	c:RegisterEffect(e4)
end
function c984379021.STMatFilter(c)
	return bit.band(c:GetType(),0x20004)==0x20004
end
function c984379021.effectfilter(e,ct)
	local p=e:GetHandler():GetControler()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and te:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function c984379021.distarget(e,c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c984379021.damfilter(c,r,rp,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and bit.band(r,0x41)==0x41 and rp~=tp
		and c:IsPreviousPosition(POS_FACEDOWN)
end
function c984379021.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(c984379021.damfilter,1,nil,r,rp,c:GetControler())
end
function c984379021.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c984379021.damop(e,tp,eg,ep,ev,re,r,rp)
	local rt=eg:FilterCount(c984379021.damfilter,nil,r,rp,e:GetHandler():GetControler())*500
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Damage(p,rt,REASON_EFFECT)
end
