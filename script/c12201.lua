-- The Advanced Seal Of Orichalcos
function c12201.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c12201.atcon)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c12201.efilter)
	c:RegisterEffect(e2)
	--Atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,LOCATION_OFFFIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetTarget(c12201.filter)
	e3:SetValue(500)
	c:RegisterEffect(e3)
	--activation
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	e4:SetValue(c12201.dfilter)
	c:RegisterEffect(e4)
	--Life point
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_RECOVER)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLE_DESTROYED)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCost(c12201.cost)
	e5:SetTarget(c12201.tg)
	e5:SetOperation(c12201.op)
	c:RegisterEffect(e5)
	--Extra summon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e6:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e6:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e6:SetCode(EFFECT_EXTRA_SET_COUNT)
	c:RegisterEffect(e7)
end
function c12201.atcon(e)
	local tc=Duel.GetFieldCard(e:GetHandler():GetControler(),LOCATION_SZONE,5)	
	return tc~=nil and tc:IsFaceup()
end
function c12201.efilter(e,te)
	return te:IsActiveType(TYPE_QUICKPLAY+TYPE_COUNTER+TYPE_SPELL+TYPE_TRAP+TYPE_EFFECT)
end

function c12201.filter(e,c)
	return c:IsAttribute(ATTRIBUTE_DARK+ATTRIBUTE_LIGHT+ATTRIBUTE_WATER+ATTRIBUTE_FIRE+ATTRIBUTE_EARTH+ATTRIBUTE_WIND)
end
function c12201.dfilter(e,re,tp)
	return re:GetHandler():IsType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c12201.afilter(g,tp)
	local c=g:GetFirst()
	if c:IsControler(1-tp) then c=g:GetNext() end
	if c and c:IsLocation(LOCATION_GRAVE) then return c end
	return nil
end
function c12201.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local rc=c12201.afilter(eg,tp)
		return rc and rc:IsAbleToRemoveAsCost()
	end
	local rc=c12201.afilter(eg,tp)
	e:SetLabel(rc:GetAttack())
	Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
end
function c12201.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetLabel())
end
function c12201.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
