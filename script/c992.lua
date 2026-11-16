--平行世界融合
--Parallel World Fusion
local s,id=GetID()
function s.initial_effect(c)
	--Apply the effect of 1 non-Rock "Shaddoll" monster in your GY that activates when it is flipped face-up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
		e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.drcost)
	e1:SetTarget(s.applytg)
	e1:SetOperation(s.applyop)
	c:RegisterEffect(e1)
	--Activate
	local e2=Fusion.CreateSummonEff(c,aux.FilterBoolFunction(Card.IsSetCard,SET_SHADDOLL),aux.FALSE,s.fextra,Fusion.ShuffleMaterial)
	e1:SetDescription(aux.Stringid(id,1))
	c:RegisterEffect(e2)
end
s.listed_series={SET_SHADDOLL}
function s.fextra(e,tp,mg)
	return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsFaceup,Card.IsAbleToDeck),tp,LOCATION_REMOVED+LOCATION_GRAVE+LOCATION_HAND+LOCATION_ONFIELD,0,nil)
end
function s.applyfilter(c,e,tp)
	if c:IsCode(id) then return false end
	if not (c:IsSetCard(SET_SHADDOLL) and c:IsMonster()) then return false end
	local effs={c:GetOwnEffects()}
	for _,eff in ipairs(effs) do
		if eff:GetType()&EFFECT_TYPE_FLIP>0 or eff:GetCode()==EVENT_FLIP then
			local tg=eff:GetTarget()
			if tg==nil or tg(eff,tp,Group.CreateGroup(),PLAYER_NONE,0,e,REASON_EFFECT,PLAYER_NONE,0) then
				return true
			end
		end
	end
	return false
end
function s.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function s.applytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(s.applyfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,s.applyfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	local available_effs={}
	local effs={tc:GetOwnEffects()}
	for _,eff in ipairs(effs) do
		if eff:GetType()&EFFECT_TYPE_FLIP>0 or eff:GetCode()==EVENT_FLIP then
			local tg=eff:GetTarget()
			if tg==nil or tg(eff,tp,Group.CreateGroup(),PLAYER_NONE,0,e,REASON_EFFECT,PLAYER_NONE,0) then
				table.insert(available_effs,eff)
			end
		end
	end
	local eff=nil
	if #available_effs>1 then
		local available_effs_desc={}
		for _,eff in ipairs(available_effs) do
			table.insert(available_effs_desc,eff:GetDescription())
		end
		local op=Duel.SelectOption(tp,table.unpack(available_effs_desc))
		eff=available_effs[op+1]
	else
		eff=available_effs[1]
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,eff:GetDescription())
	Duel.ClearTargetCard()
	tc:CreateEffectRelation(e)
	e:SetLabel(eff:GetLabel())
	e:SetLabelObject(eff:GetLabelObject())
	local tg=eff:GetTarget()
	if tg then
		tg(e,tp,eg,ep,ev,re,r,rp,1)
		eff:SetLabel(e:GetLabel())
		eff:SetLabelObject(e:GetLabelObject())
	end
	e:SetLabelObject(eff)
	Duel.ClearOperationInfo(0)
end
function s.applyop(e,tp,eg,ep,ev,re,r,rp)
	local eff=e:GetLabelObject()
	if not (eff and eff:GetHandler():IsRelateToEffect(e)) then return end
	e:SetLabel(eff:GetLabel())
	e:SetLabelObject(eff:GetLabelObject())
	local op=eff:GetOperation()
	if op then
		op(e,tp,Group.CreateGroup(),PLAYER_NONE,0,e,REASON_EFFECT,PLAYER_NONE)
	end
	e:SetLabel(0)
	e:SetLabelObject(nil)
end

