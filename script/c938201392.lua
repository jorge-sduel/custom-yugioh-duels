--Emblem-Eyes Restrict
if not Rune then Duel.LoadScript("proc_rune.lua") end
function c938201392.initial_effect(c)
	--Rune Summon
	c:EnableReviveLimit()
	Rune.AddProcedure(c,Rune.MonFunctionEx(Card.IsSetCard,0x110),1,1,Rune.STFunctionEx(Card.IsType,TYPE_EQUIP),1,1,LOCATION_GRAVE)
	--equip
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(63519819,0))
    e1:SetCategory(CATEGORY_EQUIP)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1)
    e1:SetCondition(c938201392.eqcon)
    e1:SetTarget(c938201392.eqtg)
    e1:SetOperation(c938201392.eqop)
    c:RegisterEffect(e1)
    aux.AddEREquipLimit(c,c938201392.eqcon,function(ec,_,tp) return ec:IsControler(1-tp) end,c938201392.equipop,e1)
	--special summon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(40509732,0))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_LEAVE_FIELD)
    e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
    e2:SetCondition(c938201392.descon)
    e2:SetTarget(c938201392.destg)
    e2:SetOperation(c938201392.desop)
    c:RegisterEffect(e2)
    --atk/def
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_UPDATE_ATTACK)
    e4:SetCondition(c938201392.adcon)
    e4:SetValue(c938201392.atkval)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCode(EFFECT_UPDATE_DEFENSE)
    e5:SetCondition(c938201392.adcon)
    e5:SetValue(c938201392.defval)   
    c:RegisterEffect(e5)
end
function c938201392.eqcon(e,tp,eg,ep,ev,re,r,rp)
    local g=e:GetHandler():GetEquipGroup():Filter(c938201392.eqfilter,nil)
    return g:GetCount()==0
end
function c938201392.eqfilter(c)
    return c:GetFlagEffect(63519819)~=0 
end
function c938201392.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsAbleToChangeControler() end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
        and Duel.IsExistingTarget(Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
    local g=Duel.SelectTarget(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c938201392.equipop(c,e,tp,tc)
    if not aux.EquipByEffectAndLimitRegister(c,e,tp,tc,63519819) then return end
    --substitute
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_EQUIP)
    e2:SetCode(EFFECT_DESTROY_SUBSTITUTE)
    e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e2:SetReset(RESET_EVENT+0x1fe0000)
    e2:SetValue(1)
    tc:RegisterEffect(e2)       
end
function c938201392.eqop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) and tc:IsControler(1-tp) then
        if c:IsFaceup() and c:IsRelateToEffect(e) then
            c938201392.equipop(c,e,tp,tc)
        else Duel.SendtoGrave(tc,REASON_EFFECT) end
    end
end
function c938201392.descon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:GetReasonPlayer()~=tp and c:IsReason(REASON_EFFECT) and c:IsPreviousPosition(POS_FACEUP)
        and c:GetPreviousControler()==c:GetOwner()
end
function c938201392.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c938201392.desop(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
    Duel.Destroy(sg,REASON_EFFECT)
end

function c938201392.adcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local g=c:GetEquipGroup():Filter(c938201392.eqfilter,nil)
    return g:GetCount()>0
end
function c938201392.atkval(e,c)
    local c=e:GetHandler()
    local g=c:GetEquipGroup():Filter(c938201392.eqfilter,nil)
    local atk=g:GetFirst():GetTextAttack()
    if g:GetFirst():IsFacedown() or bit.band(g:GetFirst():GetOriginalType(),TYPE_MONSTER)==0 or atk<0 then
        return 0
    else
        return atk
    end
end
function c938201392.defval(e,c)
    local c=e:GetHandler()
    local g=c:GetEquipGroup():Filter(c938201392.eqfilter,nil)
    local def=g:GetFirst():GetTextDefense()
    if g:GetFirst():IsFacedown() or bit.band(g:GetFirst():GetOriginalType(),TYPE_MONSTER)==0 or def<0 then
        return 0
    else
        return def
    end
end
