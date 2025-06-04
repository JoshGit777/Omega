--!strict

local Omega = {
	Loaded = nil,
}
Omega.__index = Omega

local NPC = require(script:WaitForChild("NPC"))
local Enums = require(script:WaitForChild("Enums"))
local State = require(script:WaitForChild("State"))
local Typings = require(script:WaitForChild("Typings"))

type Omega = Typings.Omega

function Omega.create(): Omega
	if Omega.Loaded then
		return Omega.Loaded
	end

	local self: Omega = setmetatable({} :: any, Omega)

	self.Entities = {}

	return self
end

function Omega.RegisterModelFolder(self: Omega, Folder: Folder)
	self.ModelFolder = Folder
end

function Omega.RegisterConfigurationFolder(self: Omega, Configuration: Configuration)
	self.ConfigurationFolder = Configuration
end

function Omega.NPC(self: Omega, Name: string, SpawnCFrame: CFrame?): Typings.NPC
	return NPC.create(self, Name, SpawnCFrame)
end

return Omega.create()
