--Evo Xyz
function c12340426.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,c12340426.xyzfilter,nil,2,c12340426.ovfilter,aux.Stringid(12340426,0),99,c12340426.xyzop,false,c12340426.xyzcheck)
	--add xyz materials
	local exyz=Effect.CreateEffect(c)
	exyz:SetDescription(aux.Stringid(12340426,1))
	exyz:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	exyz:SetCode(EVENT_SPSUMMON_SUCCESS)
	exyz:SetCondition(c12340426.con)
	exyz:SetTarget(c12340426.tg)
	exyz:SetOperation(c12340426.op)
	c:RegisterEffect(exyz)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--indestructable by effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c12340426.econ)
	e1:SetValue(c12340426.imfilter)
	c:RegisterEffect(e1)
	--atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(c12340426.econ)
	e2:SetValue(c12340426.adval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--remove material
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12340426,2))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c12340426.rmcon)
	e4:SetOperation(c12340426.rmop)
	c:RegisterEffect(e4)
end

function c12340426.xyzfilter(c,xyz,sumtype,tp)
	return c:IsType(TYPE_XYZ,xyz,sumtype,tp) and c:IsRace(RACE_REPTILE) and c:IsRank(6)
end
function c12340426.xyzcheck(g,tp,xyz)
	local mg=g:Filter(function(c) return not c:IsHasEffect(511001175) end,nil)
	return mg:GetClassCount(Card.GetRank)==1
end
function c12340426.ovfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_REPTILE) and c:IsType(TYPE_XYZ) and c:IsRank(6) and c:GetOverlayCount()==0
end
function c12340426.cfilter(c)
	return c:IsRace(RACE_REPTILE) and c:IsType(TYPE_XYZ) and c:IsRank(6)
end
function c12340426.xyzop(e,tp,chk,mc)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(12340426,RESET_EVENT+0x6e0000,0,1)
	return true
end

function c12340426.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(12340426)~=0
		and e:GetHandler():GetSummonType()==SUMMON_TYPE_XYZ
end
function c12340426.filter(c)
	return c:IsRace(RACE_REPTILE) and c:IsType(TYPE_XYZ)
end
function c12340426.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c12340426.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12340426.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c12340426.filter,tp,LOCATION_GRAVE,0,1,99,nil)
end
function c12340426.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.Overlay(c,sg)
		Duel.SetLP(tp,Duel.GetLP(tp)-sg:GetCount()*500)
	end
end

function c12340426.econ(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c12340426.imfilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end

function c12340426.adval(e,c)
	return e:GetHandler():GetOverlayCount()*500
end

function c12340426.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
		and e:GetHandler():GetOverlayCount()>0
end
function c12340426.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetOverlayCount()>0 then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	end
end