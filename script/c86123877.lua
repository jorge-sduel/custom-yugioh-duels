--Silent Feather Dragon
function c86123877.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,false,true,c86123877.fusfilter1,c86123877.fusfilter2,c86123877.fusfilter3,c86123877.fusfilter4)
	s.max_material_count=0
	--level/rank
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_RANK_LEVEL_S)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c86123877.spcon)
	e1:SetOperation(c86123877.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e2)
	--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(86123877,0))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(c86123877.descost)
	e4:SetTarget(c86123877.destg)
	e4:SetOperation(c86123877.desop)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT) 
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--recover
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(86123877,0))
	e6:SetCategory(CATEGORY_RECOVER)	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EVENT_BATTLE_DESTROYING)
	e6:SetCondition(c86123877.reccon)
	e6:SetTarget(c86123877.rectg)
	e6:SetOperation(c86123877.recop)
	c:RegisterEffect(e6)
	--PENDULUM
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetCode(EFFECT_ADD_TYPE)
	e9:SetValue(TYPE_PENDULUM)
	c:RegisterEffect(e9)
	--Atk up
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetRange(LOCATION_SZONE)
	e10:SetTargetRange(LOCATION_MZONE,0)
	e10:SetCode(EFFECT_UPDATE_ATTACK)
	e10:SetCondition(c86123877.con)
	e10:SetValue(700)
	c:RegisterEffect(e10)
	--send replace
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
	e11:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e11:SetCondition(c86123877.repcon)
	e11:SetOperation(c86123877.repop)
	c:RegisterEffect(e11)
end
c86123877.miracle_synchro_fusion=true
function c86123877.fusfilter1(c)
	return c:IsType(TYPE_FUSION)
end
function c86123877.fusfilter2(c)
	return c:IsType(TYPE_SYNCHRO)
end
function c86123877.fusfilter3(c)
	return c:IsType(TYPE_XYZ)
end
function c86123877.fusfilter4(c)
	return c:IsType(TYPE_PENDULUM)
end
function c86123877.spcostfilter(c)
	return c:IsFaceup() and c:IsAbleToRemoveAsCost() and c:IsType(TYPE_PENDULUM+TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
end
c86123877.spcost_table={TYPE_PENDULUM,TYPE_FUSION,TYPE_SYNCHRO,TYPE_XYZ}
function c86123877.spcost_selector(c,tp,g,sg,i)
	if not c:IsType(c86123877.spcost_table[i]) then return false end
	sg:AddCard(c)
	g:RemoveCard(c)
	local flag=false
	if i<4 then
		flag=g:IsExists(c86123877.spcost_selector,1,nil,tp,g,sg,i+1)
	else
		flag=Duel.GetMZoneCount(tp,sg,tp)>0
	end
	sg:RemoveCard(c)
	g:AddCard(c)
	return flag
end
function c86123877.spcon(e,c)
	if c==nil then return true end
	local tp=c:IsControler(tp)
	local g=Duel.GetMatchingGroup(c86123877.spcostfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local sg=Group.CreateGroup()
	return g:IsExists(c86123877.spcost_selector,1,nil,tp,g,sg,1)
end
function c86123877.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c86123877.spcostfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local sg=Group.CreateGroup()
	for i=1,4 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g1=g:FilterSelect(tp,c86123877.spcost_selector,1,1,nil,tp,g,sg,i)
		sg:Merge(g1)
		g:Sub(g1)
	end
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c86123877.cfilter(c)
	return c:IsDiscardable()
end
function c86123877.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c86123877.cfilter,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c86123877.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c86123877.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c86123877.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c86123877.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c86123877.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c86123877.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c86123877.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c86123877.reccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE)
end
function c86123877.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local rec=bc:GetBaseAttack()
	if rec<0 then rec=0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(rec)	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,rec)
end
function c86123877.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c86123877.con(e)
	local ph=Duel.GetCurrentPhase()
	local tp=Duel.GetTurnPlayer()
	return tp==e:GetHandlerPlayer() and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c86123877.repcon(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function c86123877.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	Duel.RaiseEvent(c,EVENT_CUSTOM+47408488,e,0,tp,0,0)
end

