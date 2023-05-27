--
local s,id=GetID()
function s.initial_effect(c)
	--cos
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(89312388,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(s.coscost)
	e1:SetOperation(s.cosoperation)
	c:RegisterEffect(e1)
end
function s.getprops(c)
	return math.max(0,c:GetTextAttack()),math.max(0,c:GetTextDefense()),
		c:GetOriginalLevel(),c:GetOriginalRace(),c:GetOriginalAttribute()
end
function s.filter(c,code)
	return c:IsAbleToGraveAsCost() and c:IsMonster() and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0x1034,TYPES_TOKEN,s.getprops(c))
end
function s.coscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil,e:GetHandler():GetCode()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cg=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil,e:GetHandler():GetCode())
	Duel.SendtoGrave(cg,REASON_COST)
	e:SetLabel(cg:GetFirst())
end
function s.cosoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0x1034,TYPES_TOKEN,s.getprops(tc)) then
		local token=Duel.CreateToken(tp,id+1)
		-- Change Type, Attribute, Level, and ATK/DEF
		token:Race(tc:GetOriginalRace())
		token:Attribute(tc:GetOriginalAttribute())
		token:Level(tc:GetOriginalLevel())
		token:Attack(math.max(0,tc:GetTextAttack()))
		token:Defense(math.max(0,tc:GetTextDefense()))
		Duel.BreakEffect()
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
end
function s.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end