--SS fusion
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Fusion.CreateSummonEff(c,nil,aux.FALSE,s.fextra,Fusion.ShuffleMaterial)
	c:RegisterEffect(e1)
end
s.listed_series={0x3008}
function s.fextra(e,tp,mg)
	return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsFaceup,Card.IsAbleToDeck),tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
end
