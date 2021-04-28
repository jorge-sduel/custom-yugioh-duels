--Ritual Spell
function c12340315.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCountLimit(1,12340315+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c12340315.target)
	e1:SetOperation(c12340315.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12340315,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_GRAVE)
	--e2:SetCountLimit(1,12340315+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c12340315.thcon)
	e2:SetTarget(c12340315.thtg)
	e2:SetOperation(c12340315.thop)
	c:RegisterEffect(e2)
end

function c12340315.filter(c,e,tp,m,ft)
	if not c:IsAttribute(ATTRIBUTE_DARK) or not c:IsType(TYPE_RITUAL)
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c):Filter(Card.IsAttribute,nil,ATTRIBUTE_DARK)
	if ft>0 then
		return mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetLevel(),c)
	else
		return mg:IsExists(c12340315.filterF,1,nil,tp,mg,c)
	end
end
function c12340315.filterF(c,tp,mg,rc)
	if c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) then
		Duel.SetSelectedCard(c)
		return mg:CheckWithSumGreater(Card.GetRitualLevel,rc:GetLevel(),rc)
	else return false end
end
function c12340315.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		return ft>-1 and Duel.IsExistingMatchingCard(c12340315.filter,tp,LOCATION_HAND,0,1,nil,e,tp,mg,ft)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c12340315.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c12340315.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,mg,ft)
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc):Filter(Card.IsAttribute,nil,ATTRIBUTE_DARK)
		local mat=nil
		if ft>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
		else
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			mat=mg:FilterSelect(tp,c12340315.filterF,1,1,nil,tp,mg,tc)
			Duel.SetSelectedCard(mat)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local mat2=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,tc:GetLevel(),tc)
			mat:Merge(mat2)
		end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end

function c12340315.thcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetDrawCount(tp)>0
        and e:GetHandler():IsAbleToHand() and Duel.IsExistingMatchingCard(c12340315.thfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c12340315.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c12340315.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand()
        and Duel.IsExistingMatchingCard(c12340315.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
        
	local dt=Duel.GetDrawCount(tp)
	if dt~=0 then
		_replace_count=0
		_replace_max=dt
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_DRAW_COUNT)
		e1:SetTargetRange(1,0)
		e1:SetReset(RESET_PHASE+PHASE_DRAW)
		e1:SetValue(0)
		Duel.RegisterEffect(e1,tp)
	end
    
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c12340315.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	_replace_count=_replace_count+1
	if _replace_count<=_replace_max and c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,c12340315.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
        if g:GetCount()>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
	end
end