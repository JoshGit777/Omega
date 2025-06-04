local OmegaModule = script.Parent
local Typings = require(OmegaModule:WaitForChild("Typings"))
local RunService = game:GetService("RunService")

local function HandleStates(NPC: Typings.NPC)
	local LoadedState = NPC.State

	local StateHandler = RunService.Heartbeat:Connect(function()
		local NextState

		for _, state in pairs(NPC.LoadedStates) do
			state:Update()
			if state.Active == true then
				NextState = LoadedState
				break
			end
		end

		if NextState then
			NPC.State = LoadedState
		end
	end)

	table.insert(NPC.Cache, StateHandler)
end

return HandleStates
