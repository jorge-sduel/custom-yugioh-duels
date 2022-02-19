--created by Swag, coded by Lyris
--Not yet finalized values
--Custom constants
EFFECT_CANNOT_BE_TIMELEAP_MATERIAL	=825
EFFECT_MUST_BE_TIMELEAP_MATERIAL	=826
EFFECT_FUTURE						=827
EFFECT_EXTRA_TIMELEAP_MATERIAL		=828
EFFECT_EXTRA_TIMELEAP_SUMMON		=829
EFFECT_IGNORE_TIMELEAP_HOPT			=830
TYPE_TIMELEAP						=0x10000000000
CTYPE_TIMELEAP						=0x100
SUMMON_TYPE_TIMELEAP				=SUMMON_TYPE_SPECIAL+825

REASON_TIMELEAP	=0x10000000000

if not aux.TimeleapProcedure then
	aux.TimeleapProcedure = {}
	Timeleap = aux.TimeleapProcedure
end
if not timeleap then
	Timeleap = aux.TimeleapProcedure
end
--[[
add at the start of the script to add timeleap procedure
if not TIMELEAP_IMPORTED then Duel.LoadScript("proc_timeleap.lua") end
condition if Timeleap summoned
    return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_TYPE_EVOLUTE
]]
end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(Auxiliary.TimeleapCondition(sumcon,filter,table.unpack(list)))
	e1:SetTarget(Auxiliary.TimeleapTarget(filter,table.unpack(list)))
	e1:SetOperation(Auxiliary.TimeleapOperation(customop))
	e1:SetValue(825)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_FUTURE)
	e2:SetValue(Auxiliary.FutureVal(futureval))
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function Auxiliary.TimeleapCondition(sumcon,filter,...)
	local funs={...}
	return  function(e,c)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				
				local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_TIMELEAP_SUMMON)}
				local exsumcheck=false
				for _,te in ipairs(eset) do
					if not te:GetValue() or type(te:GetValue())=="number" or te:GetValue()(e,c) then
						exsumcheck=true
					end
				end
				
				local mg=Duel.GetMatchingGroup(Card.IsCanBeTimeleapMaterial,tp,LOCATION_MZONE,0,nil,c)
				local mg2=Duel.GetMatchingGroup(Auxiliary.TimeleapExtraFilter,tp,0xff,0xff,nil,f,c,tp,table.unpack(funs))
				if mg2:GetCount()>0 then mg:Merge(mg2) end
				local fg=aux.GetMustMaterialGroup(tp,EFFECT_MUST_BE_TIMELEAP_MATERIAL)
				if fg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(fg)
				return (not sumcon or sumcon(e,c))
					and (Duel.GetFlagEffect(tp,828)<=0 or (exsumcheck and Duel.GetFlagEffect(tp,830)<=0) or c:IsHasEffect(EFFECT_IGNORE_TIMELEAP_HOPT))
					and mg:IsExists(Auxiliary.TimeleapMaterialFilter,1,nil,filter,e,tp,Group.CreateGroup(),mg,c,0,table.unpack(funs))
			end
end
function Auxiliary.TimeleapExtraFilter(c,f,lc,tp,...)
	local flist={...}
	local check=false
	if (not f or f(c)) then check=true end
	for i=1,#flist do
		if flist[i][1]~=999 and flist[i][1](c) then
			check=true
		end
	end
	local tef1={c:IsHasEffect(EFFECT_EXTRA_TIMELEAP_MATERIAL,tp)}
	local ValidSubstitute=false
	for _,te1 in ipairs(tef1) do
		local con=te1:GetCondition()
		if (not con or con(c,ec,1)) then ValidSubstitute=true end
	end
	if not ValidSubstitute then return false end
	if c:IsLocation(LOCATION_ONFIELD) and not c:IsFaceup() then return false end
	return c:IsCanBeTimeleapMaterial(lc) and check
end
function Auxiliary.TimeleapMaterialFilter(c,filter,e,tp,sg,mg,bc,ct,...)
	sg:AddCard(c)
	ct=ct+1
	local funs,max,chk={...},1
	if (not filter or filter(c,e,mg)) and c:GetLevel()==bc:GetFuture()-1 then
		chk=true
	end
	if #funs>0 then
		for i=1,#funs do
			if funs[i][1]~=999 then 
				max=max+funs[i][3]
			else
				max=funs[i][3]
			end
			if funs[i][1]~=999 and funs[i][1](c,e,mg) then
				chk=true
			end
		end
	end
	if max>99 then max=99 end
	local res=chk and (Auxiliary.TimeleapCheckGoal(tp,sg,bc,ct,table.unpack(funs))
		or (ct<max and mg:IsExists(Auxiliary.TimeleapMaterialFilter,1,sg,filter,e,tp,sg,mg,bc,ct,table.unpack(funs))))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
function Auxiliary.TimeleapCheckGoal(tp,sg,bc,ct,...)
	local funs,min={...},1
	if #funs>0 then
		for i=1,#funs do
			if funs[i][1]~=999 and not sg:IsExists(funs[i][1],funs[i][2],nil) then return false end
			if funs[i][1]~=999 then 
				min=min+funs[i][2]
			else
				min=funs[i][2]
			end
		end
	end
	return ct>=min and Duel.GetLocationCountFromEx(tp,tp,sg,bc)>0 and not sg:IsExists(Auxiliary.TimeleapUncompatibilityFilter,1,nil,sg,bc,tp)
end
function Auxiliary.TimeleapUncompatibilityFilter(c,sg,lc,tp)
	local mg=sg:Filter(aux.TRUE,c)
	return not Auxiliary.TimeleapCheckOtherMaterial(c,mg,lc,tp)
end
function Auxiliary.TimeleapCheckOtherMaterial(c,mg,lc,tp)
	local le={c:IsHasEffect(EFFECT_EXTRA_TIMELEAP_MATERIAL,tp)}
	for _,te in pairs(le) do
		local f=te:GetValue()
		if f and type(f)=="function" and not f(te,lc,mg) then return false end
	end
	return true
end
function Auxiliary.TimeleapTarget(filter,...)
	local funs,min,max={...},1,1
	for i=1,#funs do
		if funs[i][1]~=999 then
			min=min+funs[i][2] 
			max=max+funs[i][3]
		else
			min=funs[i][2] 
			max=funs[i][3]
		end
	end
	if max>99 then max=99 end
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c)
				local mg=Duel.GetMatchingGroup(Card.IsCanBeTimeleapMaterial,tp,LOCATION_MZONE,0,nil,c)
				local mg2=Duel.GetMatchingGroup(Auxiliary.TimeleapExtraFilter,tp,0xff,0xff,nil,f,c,tp,table.unpack(funs))
				if mg2:GetCount()>0 then mg:Merge(mg2) end
				local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_TIMELEAP_SUMMON)}
				local exsumcheck
				local bg=Group.CreateGroup()
				local ce={Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_TIMELEAP_MATERIAL)}
				for _,te in ipairs(ce) do
					local tc=te:GetHandler()
					if tc then bg:AddCard(tc) end
				end
				if #bg>0 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
					bg:Select(tp,#bg,#bg,nil)
				end
				local sg=Group.CreateGroup()
				sg:Merge(bg)
				local finish=false
				local options={}
				if #eset>0 then
					local cond=1
					if Duel.GetFlagEffect(tp,828)<=0 then
						table.insert(options,aux.Stringid(433005,15))
						cond=0
					end
					for _,te in ipairs(eset) do
						table.insert(options,te:GetDescription())
					end
					local op=Duel.SelectOption(tp,table.unpack(options))+cond
					if op>0 then
						exsumcheck=eset[op]
					end
				end
				while not (sg:GetCount()>=max) do
					finish=Auxiliary.TimeleapCheckGoal(tp,sg,c,#sg,table.unpack(funs))
					local cg=mg:Filter(Auxiliary.TimeleapMaterialFilter,sg,filter,e,tp,sg,mg,c,#sg,table.unpack(funs))
					if #cg==0 then break end
					local cancel=not finish
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
					local tc=cg:SelectUnselect(sg,tp,finish,cancel,min,max)
					if not tc then break end
					if not bg:IsContains(tc) then
						if not sg:IsContains(tc) then
							sg:AddCard(tc)
							if (sg:GetCount()>=max) then finish=true end
						else
							sg:RemoveCard(tc)
						end
					elseif #bg>0 and #sg<=#bg then
						return false
					end
				end
				if finish then
					if exsumcheck~=nil then
						Duel.RegisterFlagEffect(tp,829,RESET_PHASE+PHASE_END,0,1)
						Duel.Hint(HINT_CARD,0,exsumcheck:GetOwner():GetOriginalCode())
						--exsumcheck:Reset()
					end
					sg:KeepAlive()
					e:SetLabelObject(sg)
					return true
				else return false end
			end
end
function Auxiliary.TimeleapOperation(customop)
	return  function(e,tp,eg,ep,ev,re,r,rp,c)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				if not customop then
					Duel.Remove(g,POS_FACEUP,REASON_MATERIAL+0x10000000000)
					if Duel.GetFlagEffect(tp,829)<=0 then
						Duel.RegisterFlagEffect(tp,828,RESET_PHASE+PHASE_END,0,1)
					else
						Duel.ResetFlagEffect(tp,829)
						Duel.RegisterFlagEffect(tp,830,RESET_PHASE+PHASE_END,0,1)
					end
				else
					customop(e,tp,eg,ep,ev,re,r,rp,c,g)
				end
				g:DeleteGroup()
			end
end

function Auxiliary.TimeleapHOPT(tp)
	if Duel.GetFlagEffect(tp,829)<=0 then
		Duel.RegisterFlagEffect(tp,828,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.ResetFlagEffect(tp,829)
		Duel.RegisterFlagEffect(tp,830,RESET_PHASE+PHASE_END,0,1)
	end
end

function Card.GetFuture(c)
	if not Auxiliary.Timeleaps[c] then return 0 end
	local te=c:IsHasEffect(EFFECT_FUTURE)
	if type(te:GetValue())=='function' then
		return te:GetValue()(te,c)
	else
		return te:GetValue()
	end
end
function Card.IsFuture(c,future)
	return c:GetFuture()==future
end
function Auxiliary.FutureVal(future)
	return  function(e,c)
				local future=future
				--insert modifications here
				return future
			end
end
