--Percy's Hunting Ground
--scripted by Naim
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetRange(0x5f)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--Cannot leave the field due to effects.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetTargetRange(LOCATION_FZONE,0)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetValue(s.filter)
	Duel.RegisterEffect(e2,0)
	--prevents ctivating/setting new fields
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SSET)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(1,0)
	e3:SetTarget(s.setlimit)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(1,0)
	e4:SetValue(s.actlimit)
	c:RegisterEffect(e4)
	--add spell/set trap from the banlist
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(LOCATION_FZONE,LOCATION_FZONE)
	e5:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	--e5:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	--e5:SetCountLimit(1,id)
	e5:SetCondition(s.cond1)
	e5:SetTarget(s.target1)
	e5:SetOperation(s.oper1)
	c:RegisterEffect(e5)
end
ban_spell={1845204,2295440,4031928,18144506,19613556,23557835,32807846,33782437,42703248,42829885,43040603,511009503,46411259,55144522,58577036,60682203,70368879,72892473,73628505,74191942,75500286,79571449,81439174,83764718,53129443,12580477,85602018,511000552,511001149,24224830,65681983,91623717,41482598,81674782,511000258,45986603,70828912,67616300,71650854,76375976}
ban_trap={53923690,67443336,93595154,511000274,149,35346968,40605147,55256016,17178486,27174286,28566710,21076084,35316708,32723153,57585212,64697231,93016201,80604092,23002292,61740673,30241314,33950246,51452091,26586849,89208725,511000278,5851097,511001513,84749824,41420027,92512625,511000273}
function s.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
end
function s.filter(e,te,c)
	if not te then return false end
	local tc=te:GetOwner()
	return (te:IsActiveType(TYPE_MONSTER) and c~=tc
		or (te:IsHasCategory(CATEGORY_TOHAND+CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_TODECK+CATEGORY_RELEASE+CATEGORY_TOGRAVE+CATEGORY_FUSION_SUMMON)
		and te:IsActiveType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER)))
end
function s.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD)
end
function s.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.cond1(e,tp,eg,ep,ev,re,r,rp)
	--return Duel.GetFlagEffect(e:GetHandlerPlayer(),id)==0 and not e:GetHandler():IsStatus(STATUS_CHAINING)
	return e:GetHandler():GetFlagEffect(id+ep)==0
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 end
	Duel.SetTargetPlayer(tp)
	e:SetCategory(CATEGORY_TOHAND)
	Duel.SetOperationInfo(tp,0,CATEGORY_TOHAND,nil,1,tp,nil)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
function s.oper1(e,tp,eg,ep,ev,re,r,rp)
	local f1=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	if f1==0 then
		local num=Duel.GetRandomNumber(1,#ban_spell)
		add_spell_id=ban_spell[num]
		g1=Duel.CreateToken(tp,add_spell_id)
		Duel.SendtoHand(g1,tp,REASON_RULE)
	end
	if f1==1 then
		local num=Duel.GetRandomNumber(1,#ban_trap)
		add_trap_id=ban_trap[num]
		g2=Duel.CreateToken(tp,add_trap_id)
			if Duel.CheckLocation(tp,LOCATION_SZONE,nil) then
				f2=Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4))
					if f2==0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
					Duel.MoveToField(g2,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
					else Duel.SendtoHand(g2,tp,REASON_RULE)	end
			else
				Duel.SendtoHand(g2,tp,REASON_RULE)
			end
	end
end
