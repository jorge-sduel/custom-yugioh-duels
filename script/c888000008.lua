--Evil HERO Swamp Demon
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcCode2(c,79979666,84327329,true,true)
	--lizard check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(CARD_CLOCK_LIZARD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(s.lizcon)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	--Special Summon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.EvilHeroLimit)
	c:RegisterEffect(e1)
	--defense attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DEFENSE_ATTACK)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetValue(s.atlimit)
	c:RegisterEffect(e3)
	--Increase DEF
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(s.val)
	c:RegisterEffect(e4)
end
s.material_setcode={0x8,0x3008}
s.dark_calling=true
s.listed_names={CARD_DARK_FUSION,58932615,21844576}
function s.lizcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),EFFECT_SUPREME_CASTLE)
end
function s.atlimit(e,c)
	return c~=e:GetHandler() and c:IsFaceup()
end
function s.filter(c)
	return  c:IsSetCard(0x6008) and c:IsType(TYPE_FUSION) and c:IsFaceup()
end
function s.val(e,c)
	local def=0
	local g=Duel.GetMatchingGroup(s.filter,c:GetControler(),LOCATION_MZONE,0,c)
	if g then
		for tc in aux.Next(g) do
			local cdef=tc:GetBaseDefense()
			def=def+(cdef>=0 and cdef or 0)
		end
	end
	return def/2
end
