--
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Fusion.CreateSummonEff(c,aux.FilterBoolFunction(Card.IsSetCard,SET_SHADDOLL),aux.FALSE,s.fextra,Fusion.ShuffleMaterial)
	c:RegisterEffect(e1)
end
s.listed_series={SET_SHADDOLL}
function s.fextra(e,tp,mg)
if Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsCode,81788994),tp,LOCATION_ONFIELD,0,1,nil) then
		return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsAbleToDeck),tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	end
	return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsFaceup,Card.IsAbleToDeck),tp,LOCATION_REMOVED,0,nil)
end
