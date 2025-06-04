--!strict

local OmegaModule = script.Parent
local Typings = require(OmegaModule:WaitForChild("Typings"))

local State = {}
State.__index = State

type State = Typings.State

function State.create(NPC:Typings.NPC, StateConfiguration: Typings.StateConfiguration)
	local self: State = setmetatable({} :: any, State)
    self.Priority = StateConfiguration.Priority
    self.StateConditionFunction = StateConfiguration.StateConditionFunction
    self.NPC = NPC
end

function State.Update(self:State)
    local Active = self.StateConditionFunction(self.NPC)
    self.Active = Active
end

return State
