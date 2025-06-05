local A = {}

--[=[ 
@class NPCConfiguration
A configuration file that the NPC uses.
]=]

--- @prop CharacterStateMachine ((self:NPC) -> nil)?
--- @within NPCConfiguration
--- The character state machine to set the humanoid logic of the NPC
--- Optional, as a default state machine is provided

--- @prop Functionality (self:NPC) -> nil
--- @within NPCConfiguration
--- The AI functionality of the NPC

--- @prop Attributes {}
--- @within NPCConfiguration
--- The attributes, or the properties of the NPC. These are the defaults.

--[=[
@class StateConfiguration
The configuration file that a State would use
]=]

--- @prop Priority number
--- @within StateConfiguration
--- The priority of the state

--- @prop StateConditionFunction () -> nil
--- @within StateConfiguration
--- The state condition function


return A