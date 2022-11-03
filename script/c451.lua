--Backup Gardna
local s,id=GetID()
function s.initial_effect(c)
	--Redirect Equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(s.eqtg)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
		--summon with no tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(s.ntcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.condition)
	e3:SetCost(s.cost)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(s.condition2)
	c:RegisterEffect(e4)
end
s.listed_series={0x52}
function s.filter1(c,tp)
	return c:IsFaceup() and c:GetEquipTarget()
		and Duel.IsExistingTarget(s.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,c:GetEquipTarget(),c)
end
function s.filter2(c,eqc)
	return c:IsFaceup() and eqc:CheckEquipTarget(c)
end
function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(s.filter1,tp,LOCATION_SZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,s.filter1,tp,LOCATION_SZONE,0,1,1,nil,tp)
	local eqc=g1:GetFirst()
	e:SetLabelObject(eqc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g2=Duel.SelectTarget(tp,s.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,eqc:GetEquipTarget(),eqc)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g1,1,0,0)
end
function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local eqc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	if tc==eqc then tc=g:GetNext() end
	if not eqc:IsRelateToEffect(e) then return end
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(eqc,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,eqc,tc)
end
function s.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x52)
end
function s.ntcon(e,c,minc,zone)
	if c==nil then return true end
	local tp=c:GetControler()
	return minc==0 and Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
		and (Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 or not Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil))
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local bc=tc:GetBattleTarget()
	if not tc or not bc or (tc:IsControler(1-tp) and bc:IsControler(1-tp)) then return false end
	local tcindes=false
	local bcindes=false
	if tc:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) then
		local tcind={tc:GetCardEffect(EFFECT_INDESTRUCTABLE_BATTLE)}
		for i=1,#tcind do
			local te=tcind[i]
			local f=te:GetValue()
			if type(f)=='function' then
				if f(te,bc) then tcindes=true end
			else tcindes=true end
		end
	end
	if bc:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) then
		local tcind={bc:GetCardEffect(EFFECT_INDESTRUCTABLE_BATTLE)}
		for i=1,#tcind do
			local te=tcind[i]
			local f=te:GetValue()
			if type(f)=='function' then
				if f(te,tc) then bcindes=true end
			else bcindes=true end
		end
	end
	if tcindes and bcindes then return false end
	local g=Group.CreateGroup()
	if (bc~=Duel.GetAttackTarget() or bc:IsAttackPos()) and tc:IsControler(tp) then
		if bc:IsPosition(POS_FACEUP_DEFENSE) and bc==Duel.GetAttacker() then
			if bc:IsHasEffect(EFFECT_DEFENSE_ATTACK) then
				if bc:IsHasEffect(75372290) then
					if tc:IsAttackPos() then
						if bc:GetAttack()>0 and bc:GetAttack()>=tc:GetAttack() then
							g:AddCard(tc)
						end
					else
						if bc:GetAttack()>tc:GetDefense() then
							g:AddCard(tc)
						end
					end
				else
					if tc:IsAttackPos() then
						if bc:GetDefense()>0 and bc:GetDefense()>=tc:GetAttack() then
							g:AddCard(tc)
						end
					else
						if bc:GetDefense()>tc:GetDefense() then
							g:AddCard(tc)
						end
					end
				end
			end
		else
			if tc:IsAttackPos() then
				if bc:GetAttack()>0 and bc:GetAttack()>=tc:GetAttack() then
					g:AddCard(tc)
				end
			else
				if bc:GetAttack()>tc:GetDefense() then
					g:AddCard(tc)
				end
			end
		end
	end
	if (tc~=Duel.GetAttackTarget() or tc:IsAttackPos()) and bc:IsControler(tp) then
		if tc:IsPosition(POS_FACEUP_DEFENSE) and tc==Duel.GetAttacker() then
			if tc:IsHasEffect(EFFECT_DEFENSE_ATTACK) then
				if tc:IsHasEffect(75372290) then
					if bc:IsAttackPos() then
						if tc:GetAttack()>0 and tc:GetAttack()>=bc:GetAttack() then
							g:AddCard(bc)
						end
					else
						if tc:GetAttack()>bc:GetDefense() then
							g:AddCard(bc)
						end
					end
				else
					if bc:IsAttackPos() then
						if tc:GetDefense()>0 and tc:GetDefense()>=bc:GetAttack() then
							g:AddCard(bc)
						end
					else
						if tc:GetDefense()>bc:GetDefense() then
							g:AddCard(bc)
						end
					end
				end
			end
		else
			if bc:IsAttackPos() then
				if tc:GetAttack()>0 and tc:GetAttack()>=bc:GetAttack() then
					g:AddCard(bc)
				end
			else
				if tc:GetAttack()>bc:GetDefense() then
					g:AddCard(bc)
				end
			end
		end
	end
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function s.cfilter(c,e,tp)
	return c:IsOnField() and c:IsMonster() and c:IsControler(tp) and (not e or c:IsRelateToEffect(e))
end
function s.condition2(e,tp,eg,ep,ev,re,r,rp)
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	if tg==nil then return false end
	local g=tg:Filter(s.cfilter,nil,nil,tp)
	g:KeepAlive()
	e:SetLabelObject(g)
	return ex and tc+#g-#tg>0
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetLabelObject()
	if chk==0 then return g end
	Duel.SetTargetCard(g)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(s.cfilter,nil,e,tp)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(id,0))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
