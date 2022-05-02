--Flame of Seoria
function c750.initial_effect(c)
	c:SetUniqueOnField(1,0,750)
	--send to grave
	local e20=Effect.CreateEffect(c)
	e20:SetDescription(aux.Stringid(750,14))
	e20:SetCategory(CATEGORY_TOGRAVE)
	e20:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e20:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e20:SetCode(EVENT_SPSUMMON_SUCCESS)
	e20:SetTarget(c750.ttarget)
	e20:SetOperation(c750.toperation)
	c:RegisterEffect(e20)

	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_SINGLE)
	e14:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e14:SetRange(LOCATION_MZONE)
	e14:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e14:SetValue(1)
	c:RegisterEffect(e14)
	
	local e15=e14:Clone()
	e15:SetCode(EFFECT_IMMUNE_EFFECT)
	c:RegisterEffect(e15)
	
	local e16=Effect.CreateEffect(c)
	e16:SetType(EFFECT_TYPE_SINGLE)
	e16:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e16:SetValue(1)
	c:RegisterEffect(e16)
					--special summon2 
	local e17=Effect.CreateEffect(c)
	e17:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e17:SetType(EFFECT_TYPE_IGNITION)
	e17:SetRange(LOCATION_EXTRA)
	e17:SetTarget(c750.cwsptg)
	e17:SetCondition(c750.sspcon)
	e17:SetOperation(c750.cwspop)
	c:RegisterEffect(e17)
	
		--attack target
	local e18=Effect.CreateEffect(c)
	e18:SetType(EFFECT_TYPE_SINGLE)
	e18:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e18:SetRange(LOCATION_MZONE)
	e18:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e18:SetCondition(c750.lwcon)
	e18:SetValue(1)
	c:RegisterEffect(e18)
	
	--xyz
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(750,0))
	e7:SetCategory(CATEGORY_TOGRAVE)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(c750.qcon)
	e7:SetTarget(c750.qtarget)
	e7:SetOperation(c750.qactivate)
	c:RegisterEffect(e7)
	
		--1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(750,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c750.sptg)
	e1:SetOperation(c750.spop)
	c:RegisterEffect(e1)
	
			--2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(750,2))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c750.asptg)
	e2:SetCondition(c750.acon)
	e2:SetOperation(c750.aspop)
	c:RegisterEffect(e2)
	
			--3
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(750,3))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c750.bsptg)
	e3:SetCondition(c750.bcon)
	e3:SetOperation(c750.bspop)
	c:RegisterEffect(e3)
	
				--4
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(750,4))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c750.csptg)
	e4:SetCondition(c750.ccon)
	e4:SetOperation(c750.cspop)
	c:RegisterEffect(e4)
	
				--5
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(750,5))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c750.dsptg)
	e5:SetCondition(c750.dcon)
	e5:SetOperation(c750.dspop)
	c:RegisterEffect(e5)
	
				--6
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(750,6))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(c750.esptg)
	e6:SetCondition(c750.econ)
	e6:SetOperation(c750.espop)
	c:RegisterEffect(e6)
	
				--7
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(750,7))
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1)
	e7:SetTarget(c750.fsptg)
	e7:SetCondition(c750.fcon)
	e7:SetOperation(c750.fspop)
	c:RegisterEffect(e7)
	
				--8
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(750,8))
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCountLimit(1)
	e8:SetTarget(c750.gsptg)
	e8:SetCondition(c750.gcon)
	e8:SetOperation(c750.gspop)
	c:RegisterEffect(e8)
	
				--9
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(750,9))
	e9:SetType(EFFECT_TYPE_IGNITION)
	e9:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1)
	e9:SetTarget(c750.hsptg)
	e9:SetCondition(c750.hcon)
	e9:SetOperation(c750.hspop)
	c:RegisterEffect(e9)
	
				--10
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(750,10))
	e10:SetType(EFFECT_TYPE_IGNITION)
	e10:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCountLimit(1)
	e10:SetTarget(c750.isptg)
	e10:SetCondition(c750.icon)
	e10:SetOperation(c750.ispop)
	c:RegisterEffect(e10)
	
				--11
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(750,11))
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCountLimit(1)
	e11:SetTarget(c750.jsptg)
	e11:SetCondition(c750.jcon)
	e11:SetOperation(c750.jspop)
	c:RegisterEffect(e11)
	
				--12
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(750,12))
	e12:SetType(EFFECT_TYPE_IGNITION)
	e12:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCountLimit(1)
	e12:SetTarget(c750.ksptg)
	e12:SetCondition(c750.kcon)
	e12:SetOperation(c750.kspop)
	c:RegisterEffect(e12)
	
	--fusion or synch
	local e13=Effect.CreateEffect(c)
	e13:SetDescription(aux.Stringid(750,14))
	e13:SetType(EFFECT_TYPE_IGNITION)
	e13:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCountLimit(1)
	e13:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_CARD_TARGET)
	e13:SetTarget(c750.lsptg)
	e13:SetCondition(c750.lcon)
	e13:SetOperation(c750.lspop)
	c:RegisterEffect(e13)

	--spsummon
	local e19=Effect.CreateEffect(c)
	e19:SetType(EFFECT_TYPE_SINGLE)
	e19:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e19:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e19)
	
		--selfdes
	local e21=Effect.CreateEffect(c)
	e21:SetType(EFFECT_TYPE_SINGLE)
	e21:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e21:SetRange(LOCATION_MZONE)
	e21:SetCode(EFFECT_SELF_DESTROY)
	e21:SetCondition(c750.sdcon)
	c:RegisterEffect(e21)
	
	end
	
	function c750.sdcon(e)
	return e:GetHandler():IsPosition(POS_FACEUP_DEFENCE)
end

	function c750.lwcon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c750.lfilter,c:GetControler(),LOCATION_MZONE,0,1,c)
end
function c750.lfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and not c:IsCode(750)
end

	
	--xyz add
	
		function c750.qcon(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c750.qfilter,c:GetControler(),LOCATION_MZONE,0,1,c)
end
function c750.qfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and not c:IsCode(750)
end

function c750.qtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c750.qfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c750.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,2,nil,TYPE_MONSTER) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c750.qfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c750.qactivate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
		if g:GetCount()>=1 then
			local og=g:Select(tp,1,2,nil)
			Duel.Overlay(tc,og)
		end
	end
end


	--sp summon condition
function c750.asspfilter(c)
	return c:GetRank()==1 and not c:IsCode(750)
end
function c750.bsspfilter(c)
	return c:GetRank()==2
end
function c750.csspfilter(c)
	return c:GetRank()==3
end
function c750.dsspfilter(c)
	return c:GetRank()==4
end
function c750.esspfilter(c)
	return c:GetRank()==5
end
function c750.fsspfilter(c)
	return c:GetRank()==6
end
function c750.gsspfilter(c)
	return c:GetRank()==7
end
function c750.hsspfilter(c)
	return c:GetRank()==8
end
function c750.isspfilter(c)
	return c:GetRank()==9
end
function c750.jsspfilter(c)
	return c:GetRank()==10
end
function c750.ksspfilter(c)
	return c:GetRank()==11
end
function c750.lsspfilter(c)
	return c:GetRank()==12
end



function c750.sspcon(e)
local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c750.asspfilter,c:GetControler(),LOCATION_EXTRA,0,1,c)
	and Duel.IsExistingMatchingCard(c750.bsspfilter,c:GetControler(),LOCATION_EXTRA,0,1,c)
	and Duel.IsExistingMatchingCard(c750.csspfilter,c:GetControler(),LOCATION_EXTRA,0,1,c)
	and Duel.IsExistingMatchingCard(c750.dsspfilter,c:GetControler(),LOCATION_EXTRA,0,1,c)
	and Duel.IsExistingMatchingCard(c750.esspfilter,c:GetControler(),LOCATION_EXTRA,0,1,c)
	and Duel.IsExistingMatchingCard(c750.fsspfilter,c:GetControler(),LOCATION_EXTRA,0,1,c)
	and Duel.IsExistingMatchingCard(c750.gsspfilter,c:GetControler(),LOCATION_EXTRA,0,1,c)
	and Duel.IsExistingMatchingCard(c750.hsspfilter,c:GetControler(),LOCATION_EXTRA,0,1,c)
	and Duel.IsExistingMatchingCard(c750.isspfilter,c:GetControler(),LOCATION_EXTRA,0,1,c)
	and Duel.IsExistingMatchingCard(c750.jsspfilter,c:GetControler(),LOCATION_EXTRA,0,1,c)
	and Duel.IsExistingMatchingCard(c750.ksspfilter,c:GetControler(),LOCATION_EXTRA,0,1,c)
	and Duel.IsExistingMatchingCard(c750.lsspfilter,c:GetControler(),LOCATION_EXTRA,0,1,c)
end
	
	--special summon
		function c750.cwsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function c750.cwspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,1,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end

--destroy

function c750.wfilter(c,e,tp)
	return c:IsType(TYPE_XYZ)and c:GetRank()==1 and not c:IsCode(750)
end
function c750.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c750.wfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c750.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c750.wfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end

--level 2
	function c750.acfilter(c,code)
	return c:GetRank()==1
end
	
	function c750.acon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c750.acfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,0)
	end
	
	function c750.awfilter(c,e,tp)
	return c:IsType(TYPE_XYZ)and c:GetRank()==2
end
function c750.asptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c750.awfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c750.aspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c750.awfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end

--level 3
	function c750.bcfilter(c,code)
	return c:GetRank()==2
end
	
	function c750.bcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c750.bcfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,0)
	end
	
	function c750.bwfilter(c,e,tp)
	return c:IsType(TYPE_XYZ)and c:GetRank()==3
end
function c750.bsptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c750.bwfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c750.bspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c750.bwfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end

--level 4
	function c750.ccfilter(c,code)
	return c:GetRank()==3
end
	
	function c750.ccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c750.ccfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,0)
	end
	
	function c750.cwfilter(c,e,tp)
	return c:IsType(TYPE_XYZ)and c:GetRank()==4
end
function c750.csptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c750.cwfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c750.cspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c750.cwfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
	end
	
	--level 5
	function c750.dcfilter(c,code)
	return c:GetRank()==4
end
	
	function c750.dcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c750.dcfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,0)
	end
	
	function c750.dwfilter(c,e,tp)
	return c:IsType(TYPE_XYZ)and c:GetRank()==5
end
function c750.dsptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c750.dwfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c750.dspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c750.dwfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
	end
	
		--level 6
	function c750.ecfilter(c,code)
	return c:GetRank()==5
end
	
	function c750.econ(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c750.ecfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,0)
	end
	
	function c750.ewfilter(c,e,tp)
	return c:IsType(TYPE_XYZ)and c:GetRank()==6
end
function c750.esptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c750.ewfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c750.espop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c750.ewfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
	end
	
		--level 7
	function c750.fcfilter(c,code)
	return c:GetRank()==6
end
	
	function c750.fcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c750.fcfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,0)
	end
	
	function c750.fwfilter(c,e,tp)
	return c:IsType(TYPE_XYZ)and c:GetRank()==7
end
function c750.fsptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c750.fwfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c750.fspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c750.fwfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
	end
	
			--level 8
	function c750.gcfilter(c,code)
	return c:GetRank()==7
end
	
	function c750.gcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c750.gcfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,0)
	end
	
	function c750.gwfilter(c,e,tp)
	return c:IsType(TYPE_XYZ)and c:GetRank()==8
end
function c750.gsptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c750.gwfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c750.gspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c750.gwfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
	end
	
			--level9
	function c750.hcfilter(c,code)
	return c:GetRank()==8
end
	
	function c750.hcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c750.hcfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,0)
	end
	
	function c750.hwfilter(c,e,tp)
	return c:IsType(TYPE_XYZ)and c:GetRank()==9
end
function c750.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c750.hwfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c750.hspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c750.hwfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
	end
	
		
			--level 10
	function c750.icfilter(c,code)
	return c:GetRank()==9
end
	
	function c750.icon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c750.icfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,0)
	end
	
	function c750.iwfilter(c,e,tp)
	return c:IsType(TYPE_XYZ)and c:GetRank()==10
end
function c750.isptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c750.iwfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c750.ispop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c750.iwfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
	end
	
				--level 11
	function c750.jcfilter(c,code)
	return c:GetRank()==10
end
	
	function c750.jcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c750.jcfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,0)
	end
	
	function c750.jwfilter(c,e,tp)
	return c:IsType(TYPE_XYZ)and c:GetRank()==11
end
function c750.jsptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c750.jwfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c750.jspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c750.jwfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
	end
	
					--level 12
	function c750.kcfilter(c,code)
	return c:GetRank()==11
end
	
	function c750.kcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c750.kcfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,0)
	end
	
	function c750.kwfilter(c,e,tp)
	return c:IsType(TYPE_XYZ)and c:GetRank()==12
end
function c750.ksptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c750.kwfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c750.kspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c750.kwfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
	end
	
	--fusion or synchro
		function c750.lcfilter(c,code)
	return c:GetRank()==12
end
	
	function c750.lcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c750.lcfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,0)
	end
	
	function c750.lwfilter(c,e,tp)
	return c:IsType(TYPE_SYNCHRO) or c:IsType(TYPE_FUSION)
end
function c750.lsptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c750.lwfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c750.lspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c750.lwfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
	end
	
	function c750.ttgfilter(c)
	return c:IsType(TYPE_EFFECT)
end
function c750.ttarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c750.ttgfilter,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c750.toperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c750.ttgfilter,tp,LOCATION_DECK,0,2,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end