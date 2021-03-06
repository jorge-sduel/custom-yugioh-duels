--クリアー・プライマル・コーア
function c30000012.initial_effect(c)
Fusion.AddProcMixN(c,true,true,c30000012.ffilter,3)
	--remove att
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_REMOVE_ATTRIBUTE)
	e1:SetValue(0x7f)
	c:RegisterEffect(e1)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(aux.fuslimit)
	c:RegisterEffect(e2)
	--cannot target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c30000012.indval)
	c:RegisterEffect(e4)
	--adjust
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(c30000012.adjustop)
	c:RegisterEffect(e5)
	--disable spsummon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,1)
	e6:SetTarget(c30000012.splimit)
	c:RegisterEffect(e6)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e5:SetLabelObject(g)
	e6:SetLabelObject(g)
	--Destroy
	local e7=Effect.CreateEffect(c)
	e7:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_BATTLE_DESTROYING)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(aux.bdocon)
	e7:SetTarget(c30000012.target)
	e7:SetOperation(c30000012.operation)
	c:RegisterEffect(e7)
end
c30000012.listed_series={0x306}
c30000012.material_setcode=0x306
function c30000012.ffilter(c,fc,sumtype,tp,sub,mg,sg)
	return c:IsSetCard(0x306,fc,sumtype,tp) and c:IsType(TYPE_FUSION) and (not sg or not sg:IsExists(s.fusfilter,1,c,c:GetCode(fc,sumtype,tp),fc,sumtype,tp))
end
function c30000012.fusfilter(c,code,fc,sumtype,tp)
	return c:IsSummonCode(fc,sumtype,tp,code) and not c:IsHasEffect(511002961)
end
function c30000012.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end

function c30000012.atfilter(c,att,tp)
	return c:IsAttribute(att) and c:IsControler(tp)
end
function c30000012.splimit(e,c,sump,sumtype,sumpos,targetp)
	local att=c:GetAttribute()
	return e:GetLabelObject():IsExists(c30000012.atfilter,1,nil,att,sump)
end
function c30000012.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local phase=Duel.GetCurrentPhase()
	if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	e:GetLabelObject():Clear()
	e:GetLabelObject():Merge(g)
end

function c30000012.filter(c,att)
	return c:IsAbleToRemove() and c:IsAttribute(att)
end
function c30000012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local att=e:GetHandler():GetBattleTarget():GetPreviousAttributeOnField()
	if chk==0 then return Duel.IsExistingMatchingCard(c30000012.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,att) end
	local g=Duel.GetMatchingGroup(c30000012.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,att)
	e:SetLabel(att)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,0)
end
function c30000012.operation(e,tp,eg,ep,ev,re,r,rp)
	local att=e:GetLabel()
	local g1=Duel.GetMatchingGroup(c30000012.filter,tp,LOCATION_MZONE,0,nil,att)
	local g2=Duel.GetMatchingGroup(c30000012.filter,tp,0,LOCATION_MZONE,nil,att)
	local damtp=0
	local damop=0
	if Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)~=0 then
		damtp=g1:GetCount()*500
	end
	if Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)~=0 then
		damop=g2:GetCount()*500
	end
	Duel.BreakEffect()
	Duel.Damage(tp,damtp,REASON_EFFECT)
	Duel.Damage(1-tp,damop,REASON_EFFECT)
end
