--created & coded by Lyris
--サイバー・ドラゴン・ティマイオス
local cid,id=GetID()
function cid.initial_effect(c)
	local f1,f2,f3=Card.IsCanBeFusionMaterial,Duel.GetMatchingGroup,Duel.GetFusionMaterial
	Card.IsCanBeFusionMaterial=function(tc,fc)
		return f1(tc,fc) or (not tc:IsHasEffect(EFFECT_CANNOT_BE_FUSION_MATERIAL) and tc:GetOriginalCode()==c:GetOriginalCode())
	end
	Duel.GetMatchingGroup=function(f,p,sloc,oloc,exc,...)
		local g=f2(f,p,sloc,oloc,exc,table.unpack{...})
		if not f or f(c,table.unpack{...}) then g:AddCard(c) end
		return g:Filter(function(c) return (c:IsControler(p) and c:IsLocation(sloc)) or (c:IsControler(1-p) and c:IsLocation(oloc)) end,nil)
	end
	Duel.GetFusionMaterial=function(p)
		local mg,loc=f3(p),c:GetLocation()
		if loc&(LOCATION_HAND+LOCATION_ONFIELD)==loc and f1(c) then mg:AddCard(c) end
		return mg
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(CARD_CYBER_DRAGON)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cid.target)
	e1:SetOperation(cid.activate)
	c:RegisterEffect(e1)
end
function cid.tgfilter(c,e,tp,n)
	return c:IsFaceup() and c:IsCode(CARD_CYBER_DRAGON) and c:IsCanBeFusionMaterial()
		and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function cid.spfilter(c,tc,tp)
	return c:IsType(TYPE_FUSION) and c:ListsCodeAsMaterial(CARD_CYBER_DRAGON)
end
function cid.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local t={}
	for i=2,6 do
		if Duel.IsExistingTarget(cid.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp,i) then table.insert(t,i) end
	end
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cid.tgfilter(chkc,e,tp,e:GetLabel()) end
	if chk==0 then return #t>0 end
	local ct=Duel.AnnounceNumber(tp,table.unpack(t))
	e:SetLabel(ct)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,cid.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,ct)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cid.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCountFromEx(tp,tp,tc)<=0 then return end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsCanBeFusionMaterial() and not tc:IsImmuneToEffect(e) then
		local ct=e:GetLabel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,cid.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,tc,tp)
		local sc=sg:GetFirst()
		if sc then
			local mg=Group.FromCards(tc)
			for i=2,ct do
				local ck=Duel.CreateToken(tp,CARD_CYBER_DRAGON)
				mg:AddCard(ck)
			end
			sc:SetMaterial(mg)
			Duel.SendtoGrave(tc,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			if Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)~=0 then
				sc:CompleteProcedure()
				if ct>3 or not Duel.SelectYesNo(tp,1113) then return end
				if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
					local e2=Effect.CreateEffect(e:GetHandler())
					e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e2:SetCode(EVENT_PHASE+PHASE_END)
					e2:SetCountLimit(1)
					e2:SetLabel(sc:GetBaseAttack())
					e2:SetLabelObject(sc)
					e2:SetReset(RESET_PHASE+PHASE_END)
					e2:SetOperation(cid.damop)
					Duel.RegisterEffect(e2,tp)
				end
				local e0=Effect.CreateEffect(e:GetHandler())
				e0:SetType(EFFECT_TYPE_FIELD)
				e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
				e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e0:SetReset(RESET_PHASE+PHASE_END)
				e0:SetTargetRange(1,0)
				e0:SetTarget(cid.splimit)
				Duel.RegisterEffect(e0,tp)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_ATTACK_FINAL)
				e1:SetValue(sc:GetAttack()*2)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				sc:RegisterEffect(e1)
			end
		end
	end
end
function cid.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:GetRace()~=RACE_MACHINE
end
function cid.damop(e,tp,eg,ep,ev,re,r,rp)
	local dam,ec=e:GetLabel(),e:GetLabelObject()
	local atk=ec:GetAttack()
	if atk>dam and atk>=ec:GetBaseAttack()*2 then
		Duel.Damage(tp,dam,REASON_EFFECT)
	end
end
