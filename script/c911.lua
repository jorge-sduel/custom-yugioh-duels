--Nightmare Doll, Alice
function c911.initial_effect(c)
	--Endless Nightmare
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(911,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c911.con)
	e1:SetCost(c911.cost)
	e1:SetOperation(c911.operation)
	c:RegisterEffect(e1)
end
function c911.con(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer() and ph==PHASE_BATTLE 
	and e:GetHandler():GetBattledGroupCount()>0
end
function c911.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c911.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c911.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	g=Duel.SelectTarget(tp,c911.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	Duel.Overlay(tc,Group.FromCards(c))
end
function c911.spfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(911)
end
function c911.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g1=tc:GetOverlayGroup()
	local sg=g1:FilterSelect(tp,c911.spfilter,1,1,nil,e,tp)
	if sg:GetCount()>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end