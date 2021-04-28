--Shapeshifter Shade
function c16989188.initial_effect(c)

	--change level
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16989188,0))
	e1:SetCategory(CATEGORY_LVCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c16989188.lvltgt)
	e1:SetOperation(c16989188.lvlop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	
	--change type
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(16989188,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(c16989188.chngtgt)
	e4:SetOperation(c16989188.chngop)
	c:RegisterEffect(e4)
end
--Level change target
function c16989188.lvltgt(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetLevel() < 12 and
							Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
end
--Level change operation
function c16989188.lvlop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local count = Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if c:IsFaceup() and c:IsRelateToEffect(e) and count > 0 and c:GetLevel() < 12 then
		
		if count + c:GetLevel() > 12 then count = 12 - c:GetLevel() end
		
		local t={}
		local i=1
		for i=1,count do 
			t[i]=i
		end
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(16989188,2))
		local choice = Duel.AnnounceNumber(tp,table.unpack(t))
	
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(choice)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
--Type change filter
function c16989188.chngfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
--Type change target
function c16989188.chngtgt(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c16989188.chngfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16989188.chngfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(16989188,3))
	Duel.SelectTarget(tp,c16989188.chngfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,e:GetHandler())
end
--Type change operation
function c16989188.chngop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c16989188.chngfilter(tc) and tc:IsRelateToEffect(e) then
		local race = tc:GetRace()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_RACE)
		e1:SetValue(race)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end