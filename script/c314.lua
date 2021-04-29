--link trap 1
function c314.initial_effect(c)
	--add type
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_ADD_TYPE)
	e0:SetValue(TYPE_LINK)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_LIMIT_ZONE)
	e1:SetValue(c314.zones)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1118)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c314.sptg)
	e2:SetOperation(c314.spop)
	c:RegisterEffect(e2)
	--recover
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(314,0))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCountLimit(1,314)
	e3:SetCondition(c314.reccon1)
	e3:SetTarget(c314.rectg1)
	e3:SetOperation(c314.recop)
	c:RegisterEffect(e3)
	--atk up/indestructable
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c314.tgtg)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetProperty(0)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetValue(300)
	c:RegisterEffect(e5)
	--add Linkmarker
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(EFFECT_ADD_LINKMARKER)
	e6:SetValue(LINK_MARKER_TOP+LINK_MARKER_TOP_RIGTH+LINK_MARKER_TOP_LEFT)
	c:RegisterEffect(e6)
	--add Linkmarker
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(EFFECT_ADD_LINKMARKER)
	e6:SetValue(LINK_MARKER_TOP)
	c:RegisterEffect(e6)
	--add Linkmarker
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetCode(EFFECT_ADD_LINKMARKER)
	e7:SetValue(LINK_MARKER_TOP_RIGTH)
	c:RegisterEffect(e7)
	--add Linkmarker
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetCode(EFFECT_ADD_LINKMARKER)
	e8:SetValue(LINK_MARKER_TOP_LEFT)
	c:RegisterEffect(e8)
end
function c314.zones(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetLinkedZone(tp)>>8) & 0xff
end
function c314.spfilter(c,e,tp,zone)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
function c314.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=e:GetHandler():GetLinkedZone(tp)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c314.spfilter(chkc,e,tp,zone) end
	if chk==0 then return Duel.IsExistingTarget(c314.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c314.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c314.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local zone=c:GetLinkedZone(tp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and zone~=0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end
function c314.mfilter(c,lc,sumtype,tp)
	return c:IsType(TYPE_MONSTER)
end
function c314.reccon1(e,tp,eg,ep,ev,re,r,rp)
	local atk=0
	eg:ForEach(function(tc)
		if tc:IsReason(REASON_DESTROY) and tc:IsReason(REASON_BATTLE+REASON_EFFECT)
			and tc:IsType(TYPE_MONSTER) and not tc:IsPreviousLocation(LOCATION_SZONE) then
			local tatk=tc:GetTextAttack()
			if tatk>atk then atk=tatk end
		end
	end)
	if atk>0 then e:SetLabel(atk) end
	return atk>0
end
function c314.rectg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local lp=e:GetLabel()
	Duel.SetTargetParam(lp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,PLAYER_NONE,lp)
end
function c314.recop(e,tp,eg,ep,ev,re,r,rp)
	local opt=Duel.SelectOption(tp,aux.Stringid(58074572,0),aux.Stringid(58074572,1))
	local p=(opt==0 and tp or 1-tp)
	local d=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c314.tgtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end

