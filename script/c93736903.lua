--Mecha Force: Delta
function c93736903.initial_effect(c)

	--synchro summon
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	
	--synchro summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(93736903,1))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c93736903.drcon)
	e1:SetTarget(c93736903.drtarg)
	e1:SetOperation(c93736903.drop)
	c:RegisterEffect(e1)
	
	--leaves field
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(93736903,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCondition(c93736903.spcon)
	e2:SetTarget(c93736903.sptg)
	e2:SetOperation(c93736903.spop)
	c:RegisterEffect(e2)
	--indes
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_ADD_SETCODE)
	e9:SetValue(0x581)
	c:RegisterEffect(e9)
end
--Material group filter
function c93736903.mgfilter(c)
	return c:IsRace(RACE_MACHINE)
end
--Drawing condition
function c93736903.drcon(e,tp,eg,ep,ev,re,r,rp)

	local c=e:GetHandler()
	if c:GetSummonType()~=SUMMON_TYPE_SYNCHRO or c:GetMaterialCount()<=0 then return false end
	
	local mg=c:GetMaterial()
	return mg:IsExists(c93736903.mgfilter,1,nil)
end
--Drawing target
function c93736903.drtarg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
--Drawing
function c93736903.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
--Special Summon condition
function c93736903.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetSummonType()==SUMMON_TYPE_SYNCHRO and
			c:IsPreviousPosition(POS_FACEUP) and
			not c:IsLocation(LOCATION_DECK) and
			Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
			Duel.IsPlayerCanSpecialSummonMonster(tp,71402650,0,0x4011,800,800,2,RACE_MACHINE,ATTRIBUTE_EARTH)
end
--Special Summon target
function c93736903.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
--Special Summon operation
function c93736903.spop(e,tp,eg,ep,ev,re,r,rp)
	
	local token=Duel.CreateToken(tp,71402650)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if Duel.SelectYesNo(tp,aux.Stringid(93736903,5)) then
			local token2=Duel.CreateToken(tp,71402650)
			Duel.SpecialSummonStep(token2,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
		
	Duel.SpecialSummonComplete()
end