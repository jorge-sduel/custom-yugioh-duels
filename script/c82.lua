--Starve 
function c82.initial_effect(c)
		c:EnableReviveLimit()
	--fusion material	
Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_FIRE),aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_FIRE))
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c82.damtg)
	e1:SetOperation(c82.damop)
	c:RegisterEffect(e1)
end
function c82.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if chk==0 then return ct>0 end
	Duel.SetTargetParam(ct*400)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*400)
end
function c82.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	Duel.Damage(p,ct*400,REASON_EFFECT)
end