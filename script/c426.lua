--Number domination
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetRange(0x5f)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--Cannot leave the field due to effects.
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetTargetRange(LOCATION_FZONE,0)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetValue(s.filter)
	Duel.RegisterEffect(e2,0)
	--prevents ctivating/setting new fields
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SSET)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(1,0)
	e3:SetTarget(s.setlimit)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(1,0)
	e4:SetValue(s.actlimit)
	c:RegisterEffect(e4)
	--add spell/set trap from the banlist
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(LOCATION_FZONE,LOCATION_FZONE)
	e5:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	--e5:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	--e5:SetCountLimit(1,id)
	e5:SetOperation(s.nameop)
	c:RegisterEffect(e5)
end
ban_number={48995978,2978414,28400508,63767246,88177324,75433814
, 8165596
, 23085002
, 66547759
, 95474755
, 16037007, 
88120966, 
80117527, 
53701457, 
92015800, 
15862758, 
62541668, 
23187256, 
89477759, 
26556950, 
21858819, 
51543904, 
49032236, 
90162951, 
58820923, 
1992816, 
73445448, 
31801517, 
97403510, 
89516305, 
47387961, 
46871387, 
80796456, 
94380860, 
54719828, 
71921856, 
61399402, 
82697249, 
23649496, 
8387138, 
90590303, 
51735257, 
48739166, 
50260683, 
55470553, 
63746411, 
31437713, 
67557908, 
80764541, 
63504681, 
66011101, 
93108839, 
53244294, 
7194917, 
93568288, 
62517849, 
81330115, 
31320433, 
56292140, 
69610924, 
1426714, 
49195710, 
47805931, 
4997565, 
71166481, 
39622156, 
16259549, 
32003338, 
59479050, 
29208536, 
54191698, 
3790062, 
39972129, 
55727845, 
56051086, 
26973555, 
4019153, 
15232745, 
42230449, 
78625448, 
55935416, 
48928529, 
69058960, 
95442074, 
84124261, 
29085954, 
89642993, 
43490025, 
54366836, 
57314798, 
65305468, 
52653092}
function s.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
end
function s.filter(e,te,c)
	if not te then return false end
	local tc=te:GetOwner()
	return (te:IsActiveType(TYPE_MONSTER) and c~=tc
		or (te:IsHasCategory(CATEGORY_TOHAND+CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_TODECK+CATEGORY_RELEASE+CATEGORY_TOGRAVE+CATEGORY_FUSION_SUMMON)
		and te:IsActiveType(TYPE_SPELL+TYPE_TRAP+TYPE_MONSTER)))
end
function s.setlimit(e,c,tp)
	return c:IsType(TYPE_FIELD)
end
function s.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function s.cond1(e,tp,eg,ep,ev,re,r,rp)
	--return Duel.GetFlagEffect(e:GetHandlerPlayer(),id)==0 and not e:GetHandler():IsStatus(STATUS_CHAINING)
	return e:GetHandler():GetFlagEffect(id+ep)==0
end
function s.nameop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local num=Duel.GetRandomNumber(1,#ban_number)
		add_number_id=ban_number[num]
		g1=Duel.CreateToken(tp,add_number_id)
		Duel.SendtoHand(g1,tp,REASON_RULE)
	end
end
