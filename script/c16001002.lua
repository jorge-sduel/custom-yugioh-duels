--Ostrich of Doom
function c16001002.initial_effect(c)
c16001002.Is_Evolute=true
if not EVOLUTE_IMPORTED then Duel.LoadScript("proc_evolute.lua") end
	--c:EnableCounterPermit(0x88)
	c:EnableReviveLimit()
	Evolute.AddProcedure(c,nil,2,99,c16001002.rcheck) 
  --remove
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_START)
   -- e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCondition(c16001002.rmcon)
	e4:SetTarget(c16001002.rmtg)
	e4:SetOperation(c16001002.rmop)
	c:RegisterEffect(e4) 
end
function c16001002.rcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_WATER)
		and g:IsExists(Card.IsRace,1,nil,RACE_ZOMBIE) 
end
function c16001002.filter1(c,ec,tp)
	return c:IsRace(RACE_ZOMBIE) or c:IsAttribute(ATTRIBUTE_WATER)
end
function c16001002.filter2(c,ec,tp)
		return c:IsRace(RACE_ZOMBIE) or c:IsAttribute(ATTRIBUTE_WATER)
end

function c16001002.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
 return e:GetHandler():GetCounter(0x111f)==4 and e:GetHandler():IsSummonType(SUMMON_TYPE_EVOLUTE)
end

function c16001002.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
 local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if chk==0 then return tc and tc:IsFaceup() and tc:GetOriginalRace()~=RACE_ZOMBIE end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
end



function c16001002.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if tc:IsRelateToBattle() then Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)end
end
