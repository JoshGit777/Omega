local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Omega = ReplicatedStorage.Shared:WaitForChild("Omega")
local Typings = require(Omega.Typings)

return {
	Functionality = function(self:Typings.NPC)
		
	end,
	Attributes = {},
} :: Typings.NPCConfiguration
