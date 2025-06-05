--!strict

local OmegaModule = script.Parent
local Typings = require(OmegaModule:WaitForChild("Typings"))

local State = {}
State.__index = State

type State = Typings.State

--[=[
@class State

A state is, well, a state that an NPC can run on. In Omega, we use a sort of "State Machine" kind of coding style. This means that everything is a state, not just being stunned, or something that is tempoary.
So Walking, and running would be an Indivisual State. To define what state the NPC is in, each state has a ConditionFunction.
This is a function assosiated with the state, and if the ConditionFunction returns true, the state is active
Than, to determine what state an NPC is in, it goes through a priority list, and if a state is active, than the state is the selected one.

Example:
```
Stunned
Running
Walking
```

If the Stunned State has a condition function of touching a bullet, and it was touching a bullet, than it would be stunned.
But if the running condition function is also active, Runnning would not activate because it is behind the Stunned State.

]=]

--- @prop Priority number
--- The priority index of the state
--- @within State

--- @prop StateConditionFunction () -> boolean
--- The function that is used to figure out if the State is active
--- @within State

--- @prop NPC NPC
--- The npc associated with the state
--- @within State

--- @prop Active boolean
--- Determines whether the State is active or not
--- @within State

function State.create(NPC:Typings.NPC, StateConfiguration: Typings.StateConfiguration)
	local self: State = setmetatable({} :: any, State)
    self.Priority = StateConfiguration.Priority
    self.StateConditionFunction = StateConfiguration.StateConditionFunction
    self.NPC = NPC
end

--[=[  
Updates the state by checking the state condition function, and sets the active property
]=]

function State.Update(self:State)
    local Active = self.StateConditionFunction(self.NPC)
    self.Active = Active
end

return State
