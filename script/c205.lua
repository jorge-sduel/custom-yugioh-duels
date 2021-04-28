--神科学因子カスパール
--Mystic Factor Caspar
function c205.initial_effect(c)
	--level up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(44635489,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c205.lvtg)
	e1:SetOperation(c205.lvop)
	c:RegisterEffect(e1)
end
function c205.lvfilter(c)
	return c:IsFaceup() and not c:IsLevel(1)
end
function c205.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsFaceup() and c:IsLevelAbove(3)
		and Duel.GetMatchingGroupCount(c205.lvfilter,tp,LOCATION_MZONE,0,c)==Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)-1 end
end
function c205.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetMatchingGroup(c205.lvfilter,tp,LOCATION_MZONE,0,c)
	if c:IsRelateToEffect(e) and c:IsFaceup() and c:IsLevelAbove(3) and #tg==Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)-1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
		end
	end
end
