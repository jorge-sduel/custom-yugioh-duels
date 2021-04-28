--クリアー・モーフィーン・ミラー
function c30000011.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,30000022,aux.FilterBoolFunctionEx(Card.IsSetCard,0x306))
	--remove att
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_REMOVE_ATTRIBUTE)
	e1:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e1)
	--base attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c30000011.atkval)
	c:RegisterEffect(e2)
	--attribute
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c30000011.atttg)
	e3:SetOperation(c30000011.attop)
	c:RegisterEffect(e3)
	--to defence
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c30000011.poscon)
	e4:SetOperation(c30000011.posop)
	c:RegisterEffect(e4)
end
function c30000011.atkval(e,c)
	return c30000011.attcount(e:GetHandler():GetControler(),0,LOCATION_MZONE)*1000
end

--att count function
function c30000011.attfilter(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function c30000011.attcount(tp,loc1,loc2)
	local att=0
	if Duel.IsExistingMatchingCard(c30000011.attfilter,tp,loc1,loc2,1,nil,ATTRIBUTE_LIGHT) then att=att+1 end
	if Duel.IsExistingMatchingCard(c30000011.attfilter,tp,loc1,loc2,1,nil,ATTRIBUTE_DARK) then att=att+1 end
	if Duel.IsExistingMatchingCard(c30000011.attfilter,tp,loc1,loc2,1,nil,ATTRIBUTE_WATER) then att=att+1 end
	if Duel.IsExistingMatchingCard(c30000011.attfilter,tp,loc1,loc2,1,nil,ATTRIBUTE_FIRE) then att=att+1 end
	if Duel.IsExistingMatchingCard(c30000011.attfilter,tp,loc1,loc2,1,nil,ATTRIBUTE_EARTH) then att=att+1 end
	if Duel.IsExistingMatchingCard(c30000011.attfilter,tp,loc1,loc2,1,nil,ATTRIBUTE_WIND) then att=att+1 end
	if Duel.IsExistingMatchingCard(c30000011.attfilter,tp,loc1,loc2,1,nil,ATTRIBUTE_DEVINE) then att=att+1 end
	return att
end

--attribute
function c30000011.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c30000011.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			Duel.HintSelection(Group.FromCards(tc))
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(30000011,0))
			ac=Duel.AnnounceNumber(tp,1,2,3,4,5,6)
			local att=0
			local dice=Duel.TossDice(tp,1)
			if dice==1 then
				att=ATTRIBUTE_LIGHT
			elseif dice==2 then
				att=ATTRIBUTE_DARK
			elseif dice==3 then
				att=ATTRIBUTE_EARTH
			elseif dice==4 then
				att=ATTRIBUTE_WATER
			elseif dice==5 then
				att=ATTRIBUTE_FIRE
			else
				att=ATTRIBUTE_WIND
			end
			if dice==ac then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
				e1:SetCode(EFFECT_ADD_ATTRIBUTE)
				e1:SetValue(att)
				e1:SetReset(RESET_EVENT+0x1ff0000)
				tc:RegisterEffect(e1)				
			else
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
				e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
				e1:SetValue(att)
				e1:SetReset(RESET_EVENT+0x1ff0000)
				tc:RegisterEffect(e1)
			end
			tc=g:GetNext()
		end
	end
end

--pos
function c30000011.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttackedCount()>0
end
function c30000011.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackPos() then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end