--cekestial sword eatos
function c267.initial_effect(c)
	aux.AddEquipProcedure(c)
	--Atk Change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c267.value)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(267,1))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetTarget(c267.tgtg)
	e3:SetOperation(c267.tgop)
	c:RegisterEffect(e3)
	--to grave2
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(69303178,1))
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e5:SetCountLimit(1)
	e5:SetTarget(c267.tgtg)
	e5:SetOperation(c267.tgop)
	c:RegisterEffect(e5)
	--Equip limit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_EQUIP_LIMIT)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetValue(1)
	c:RegisterEffect(e6)
end
function c267.value(e,c)
	local g=Duel.GetMatchingGroup(Card.IsMonster,c:GetControler(),0,LOCATION_GRAVE,nil)
	local ec=e:GetHandler():GetEquipTarget()
	if ec:IsRace(RACE_FAIRY) then
		return g:GetSum(Card.GetAttack)
	else
		return 1000
	end
end
function c267.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c267.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end
