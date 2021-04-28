--クリ－ア・レフラ-ックション
function c30000003.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c30000003.attcon)
	e1:SetTarget(c30000003.atttg)
	e1:SetOperation(c30000003.attop)
	c:RegisterEffect(e1)
    --change & draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(30000003,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
    e2:SetCondition(aux.exccon)
	e2:SetCost(c30000003.cost)
	e2:SetTarget(c30000003.target)
	e2:SetOperation(c30000003.operation)
	c:RegisterEffect(e2)
end
function c30000003.cofilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x306) or c:IsCode(33900648))
end
function c30000003.attcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c30000003.cofilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c30000003.atttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end
function c30000003.attop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()	
	local c=e:GetHandler()
	if Duel.IsExistingMatchingCard(nil,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,tc) then
		if tc:IsFaceup() and tc:IsRelateToEffect(e) then
			Duel.Hint(HINT_SELECTMSG,tp,562)
			local catt=tc:GetAttribute()
            if catt~=0x1 and catt~=0x2 and catt~=0x4 and catt~=0x8 and catt~=0x10 and catt~=0x20 and catt~=0x40 then catt=0x0 end
			local att=Duel.AnnounceAttribute(tp,1,0xffff - catt)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
			e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e1:SetValue(att)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			tc:RegisterEffect(e1)
		end
	else
		if tc:IsFaceup() and tc:IsRelateToEffect(e) then
			Duel.Hint(HINT_SELECTMSG,tp,562)
			local catt=tc:GetAttribute()
			local att=Duel.AnnounceAttribute(tp,1,0xffff - catt)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_COPY_INHERIT)
			e2:SetCode(EFFECT_ADD_ATTRIBUTE)
			e2:SetValue(att)
			e2:SetReset(RESET_EVENT+0x1ff0000)
			tc:RegisterEffect(e2)
		end
	end
end
function c30000003.cfilter(c)
	return c:IsSetCard(0x306) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c30000003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c30000003.cfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c30000003.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c30000003.filter(c,e,tp)
	return c:IsFaceup() and c:GetSummonPlayer()==1-tp and (not e or c:IsRelateToEffect(e))
end
function c30000003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and eg:IsExists(c30000003.filter,1,nil,nil,tp) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c30000003.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local g=eg:Filter(c30000003.filter,nil,e,tp)
    local catt=0x0
    local tc=g:GetFirst()
    if c30000003.attcount(g)==1 then 
        catt=tc:GetAttribute()
    end
    Duel.Hint(HINT_SELECTMSG,tp,562)
    local att=Duel.AnnounceAttribute(tp,1,0xffff - catt)
    while tc do
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
        e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
        e1:SetValue(att)
        e1:SetReset(RESET_EVENT+0x1ff0000)
        tc:RegisterEffect(e1)
        tc=g:GetNext()
    end
    Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
end

--att count function
function c30000003.attfilter(c,att)
	return c:IsFaceup() and c:IsAttribute(att)
end
function c30000003.attcount(g)
	local att=0
	if g:Filter(c30000003.attfilter,nil,ATTRIBUTE_LIGHT)~=nil then att=att+1 end
	if g:Filter(c30000003.attfilter,nil,ATTRIBUTE_DARK)~=nil then att=att+1 end
	if g:Filter(c30000003.attfilter,nil,ATTRIBUTE_WATER)~=nil then att=att+1 end
	if g:Filter(c30000003.attfilter,nil,ATTRIBUTE_FIRE)~=nil then att=att+1 end
	if g:Filter(c30000003.attfilter,nil,ATTRIBUTE_EARTH)~=nil then att=att+1 end
	if g:Filter(c30000003.attfilter,nil,ATTRIBUTE_WIND)~=nil then att=att+1 end
	if g:Filter(c30000003.attfilter,nil,ATTRIBUTE_DEVINE)~=nil then att=att+1 end
	return att
end