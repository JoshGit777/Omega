local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Omega = ReplicatedStorage.Shared:WaitForChild("Omega")
local Typings = require(Omega.Typings)

return {
	Functionality = function()
		print("Running functionality")
	end,
	Attributes = {},
} :: Typings.NPCConfiguration
