--Cracking Dragon
function c86123577.initial_effect(c)
	c:EnableReviveLimit() 
	Fusion.AddProcCodeFunRep(c,60349525,aux.FilterBoolFunction(Card.IsFusionType,TYPE_LINK),2,63,true,true)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--reduce
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(86123577,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c86123577.condition)
	e2:SetTarget(c86123577.target)
	e2:SetOperation(c86123577.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end

function c86123577.matfilter(c,syncard)
	return c:IsType(TYPE_LINK) and c:IsFaceup() and c:IsCanBeFusionMaterial(syncard)
end
function c86123577.crkfilter(c,syncard)
	return c:IsCode(86123577) and c:IsCanBeFusionMaterial(syncard)
end
function c86123577.getlevel(c)
    if c:GetLevel()>0 then
        return c:GetLevel()
    elseif c:GetRank()>0 then
        return c:GetRank()
    elseif c:GetLink()>0 then
        return c:GetLink()
    end
    return 0
end
function c86123577.reufilter(c,lvl,all,min)
	return all:CheckWithSumEqual(c86123577.getlevel,lvl,min,24,c)
end
function c86123577.reucon(e,c)
	if c==nil then return true end
	if not Duel.IsExistingMatchingCard(c86123577.crkfilter,tp,LOCATION_MZONE,0,1,nil,c) then return false end
    local lvl=4
    local min=1
	local tp=c:GetControler()
	local all=Duel.GetMatchingGroup(c86123577.matfilter,tp,LOCATION_MZONE,0,nil,c)
	return c86123577.reufilter(c,lvl,all,min)
end
function c86123577.reuop(e,tp,eg,ep,ev,re,r,rp,c,tuner,mg)
    local c=e:GetHandler()
    local lvl=4
    local min=1
	local all=Duel.GetMatchingGroup(c86123577.matfilter,tp,LOCATION_MZONE,0,nil,c)
	local g=Group.CreateGroup()
	local g=Duel.SelectMatchingCard(tp,c86123477.crkfilter,tp,LOCATION_MZONE,0,1,1,nil,c)    
    if lvl>0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
        local mat=all:SelectWithSumEqual(tp,c86123577.getlevel,lvl,min,24,c)
        g:Merge(mat)
    end
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_FUSION)
end

function c86123577.condition(e,tp,eg,ep,ev,re,r,rp)
	if eg:GetCount()~=1 then return false end
	local tc=eg:GetFirst()
	return tc~=e:GetHandler() and tc:IsFaceup() and tc:GetLevel()>0 and tc:GetSummonPlayer()==1-tp
end
function c86123577.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,eg:GetFirst():GetLevel()*400)
end
function c86123577.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE) and not tc:IsImmuneToEffect(e) then
		local atk=tc:GetAttack()
		local nv=math.min(atk,tc:GetLevel()*400)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(-tc:GetLevel()*400)
		tc:RegisterEffect(e1)
		if not tc:IsHasEffect(EFFECT_REVERSE_UPDATE) then
			Duel.Damage(1-tp,nv,REASON_EFFECT)
		end
	end
end