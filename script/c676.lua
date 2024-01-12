--TOON FUSION
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Fusion.CreateSummonEff({handler=c,fusfilter=aux.FilterBoolFunction(Card.IsType,TYPE_MONSTER),
		extrafil=s.fextra,extraop=s.extraop,extratg=s.extratg})
	c:RegisterEffect(e1)
end
s.listed_names={15259703}
function s.fcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)>1
end
function s.exfilter0(c)
	return c:IsAbleToRemove()
end
function s.fextra(e,tp,mg)
	if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD,0,1,nil,15259703) and not Duel.IsPlayerAffectedByEffect(tp,CARD_SPIRIT_ELIMINATION) then
		local eg=Duel.GetMatchingGroup(s.exfilter0,tp,LOCATION_MZONE|LOCATION_GRAVE,LOCATION_GRAVE,nil)
		if #eg>0 then
			return nil
		end
	end
	return nil
end
function s.extraop(e,tc,tp,sg)
	local rg=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	if #rg>0 then
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT|REASON_MATERIAL|REASON_FUSION)
		sg:Sub(rg)
	end
end
function s.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE)
end
