EQUILIBRIUM_IMPORTED=true
if not aux.EquilibriumProcedure then
	aux.EquilibriumProcedure = {}
	Equilibrium = aux.EquilibriumProcedure
end
if not Equilibrium then
	Equilibrium = aux.EquilibriumProcedure
end
--[[
add at the start of the script to add Ingition procedure
if not EQUILIBRIUM_IMPORTED then Duel.LoadScript("proc_equilibrium.lua") end
]]
--Equilibrium Summon
--add procedure to Pendulum monster, also allows registeration of activation effect
	
