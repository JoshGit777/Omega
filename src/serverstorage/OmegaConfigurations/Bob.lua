local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Omega = ReplicatedStorage.Shared:WaitForChild("Omega")
local Typings = require(Omega.Typings)

return {
	Functionality = function(self:Typings.NPC)
		self.MoveDirection = Vector3.new(0, 0, 20)
	end,
	Attributes = {},
} :: Typings.NPCConfiguration
