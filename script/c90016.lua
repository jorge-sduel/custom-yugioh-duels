--"Cyberon Fusion"
local m=90016
local cm=_G["c"..m]
function cm.initial_effect(c)
    --"Activate"
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,90016)
    e1:SetTarget(c90016.target)
    e1:SetOperation(c90016.activate)
    c:RegisterEffect(e1)
    --
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(90016,0))
    e2:SetCategory(CATEGORY_TODECK+CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetCountLimit(1,90016)
    e2:SetCost(c90016.cost)
    e2:SetTarget(c90016.target1)
    e2:SetOperation(c90016.activate1)
    c:RegisterEffect(e2)
end
function c90016.cfilter(c)
    return c:GetSequence()>=5
end
function c90016.filter1(c,e)
    return c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
function c90016.exfilter0(c)
    return c:IsType(TYPE_LINK) and c:IsSetCard(0x20aa) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c90016.exfilter1(c,e)
    return c:IsType(TYPE_LINK) and c:IsSetCard(0x20aa) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c90016.filter2(c,e,tp,m,f,chkf)
    return c:IsType(TYPE_FUSION) and c:IsSetCard(0x20aa) and (not f or f(c))
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c90016.fcheck(tp,sg,fc)
    return sg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)<=1
end
function c90016.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local chkf=tp
        local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsAbleToGrave,nil)
        if not Duel.IsExistingMatchingCard(c90016.cfilter,tp,LOCATION_MZONE,0,1,nil) then
            local sg=Duel.GetMatchingGroup(c90016.exfilter0,tp,LOCATION_GRAVE,0,nil)
            if sg:GetCount()>0 then
                mg1:Merge(sg)
                Auxiliary.FCheckAdditional=c90016.fcheck
            end
        end
        local res=Duel.IsExistingMatchingCard(c90016.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
        Auxiliary.FCheckAdditional=nil
        if not res then
            local ce=Duel.GetChainMaterial(tp)
            if ce~=nil then
                local fgroup=ce:GetTarget()
                local mg2=fgroup(ce,e,tp)
                local mf=ce:GetValue()
                res=Duel.IsExistingMatchingCard(c90016.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
            end
        end
        return res
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c90016.activate(e,tp,eg,ep,ev,re,r,rp)
    local chkf=tp
    local mg1=Duel.GetFusionMaterial(tp):Filter(c90016.filter1,nil,e)
    local exmat=false
    if not Duel.IsExistingMatchingCard(c90016.cfilter,tp,LOCATION_MZONE,0,1,nil) then
        local sg=Duel.GetMatchingGroup(c90016.exfilter1,tp,LOCATION_GRAVE,0,nil,e)
        if sg:GetCount()>0 then
            mg1:Merge(sg)
            exmat=true
        end
    end
    if exmat then Auxiliary.FCheckAdditional=c90016.fcheck end
    local sg1=Duel.GetMatchingGroup(c90016.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
    Auxiliary.FCheckAdditional=nil
    local mg2=nil
    local sg2=nil
    local ce=Duel.GetChainMaterial(tp)
    if ce~=nil then
        local fgroup=ce:GetTarget()
        mg2=fgroup(ce,e,tp)
        local mf=ce:GetValue()
        sg2=Duel.GetMatchingGroup(c90016.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
    end
    if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
        local sg=sg1:Clone()
        if sg2 then sg:Merge(sg2) end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tg=sg:Select(tp,1,1,nil)
        local tc=tg:GetFirst()
        mg1:RemoveCard(tc)
        if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
            if exmat then Auxiliary.FCheckAdditional=c90016.fcheck end
            local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
            Auxiliary.FCheckAdditional=nil
            tc:SetMaterial(mat1)
            local rg=mat1:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
            mat1:Sub(rg)
            Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
            Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
            Duel.BreakEffect()
            Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
        else
            local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
            local fop=ce:GetOperation()
            fop(ce,e,tp,tc,mat2)
        end
        tc:CompleteProcedure()
    end
end
function c90016.fsfilter0(c)
    return c:IsOnField() and c:IsAbleToRemove()
end
function c90016.fsfilter1(c,e)
    return c:IsOnField() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c90016.fsfilter2(c,e,tp,m,f,chkf)
    return c:IsType(TYPE_FUSION) and c:IsSetCard(0x20aa) and (not f or f(c))
        and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c90016.fsfilter3(c)
    return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c90016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
    Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c90016.target1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local chkf=tp
        local mg1=Duel.GetFusionMaterial(tp):Filter(c90016.fsfilter0,nil)
        local mg2=Duel.GetMatchingGroup(c90016.fsfilter3,tp,LOCATION_GRAVE,0,nil)
        mg1:Merge(mg2)
        local res=Duel.IsExistingMatchingCard(c90016.fsfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
        if not res then
            local ce=Duel.GetChainMaterial(tp)
            if ce~=nil then
                local fgroup=ce:GetTarget()
                local mg3=fgroup(ce,e,tp)
                local mf=ce:GetValue()
                res=Duel.IsExistingMatchingCard(c90016.fsfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
            end
        end
        return res
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c90016.activate1(e,tp,eg,ep,ev,re,r,rp)
    local chkf=tp
    local mg1=Duel.GetFusionMaterial(tp):Filter(c90016.fsfilter1,nil,e)
    local mg2=Duel.GetMatchingGroup(c90016.fsfilter3,tp,LOCATION_GRAVE,0,nil)
    mg1:Merge(mg2)
    local sg1=Duel.GetMatchingGroup(c90016.fsfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
    local mg3=nil
    local sg2=nil
    local ce=Duel.GetChainMaterial(tp)
    if ce~=nil then
        local fgroup=ce:GetTarget()
        mg3=fgroup(ce,e,tp)
        local mf=ce:GetValue()
        sg2=Duel.GetMatchingGroup(c90016.fsfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
    end
    if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
        local sg=sg1:Clone()
        if sg2 then sg:Merge(sg2) end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local tg=sg:Select(tp,1,1,nil)
        local tc=tg:GetFirst()
        if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
            local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
            tc:SetMaterial(mat1)
            Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
            Duel.BreakEffect()
            Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
        else
            local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
            local fop=ce:GetOperation()
            fop(ce,e,tp,tc,mat2)
        end
        tc:CompleteProcedure()
        --"Indestructable"
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetDescription(aux.Stringid(90016,1))
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_NO_TURN_RESET)
        e1:SetRange(LOCATION_ONFIELD)
        e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
        e1:SetCountLimit(1)
        e1:SetValue(c90016.indct)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1)
    end
end
function c90016.indct(e,re,r,rp)
    if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
        return 1
    else return 0 end
end
