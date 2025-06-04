--!strict

local Omega = {
	Loaded = nil,
}
Omega.__index = Omega

local NPC = require(script:WaitForChild("NPC"))
local Typings = require(script:WaitForChild("Typings"))
local Identification = require(script:WaitForChild("Identification"))

type Omega = Typings.Omega

function Omega.create(): Omega
	if Omega.Loaded then
		return Omega.Loaded
	end

	local self: Omega = setmetatable({} :: any, Omega)

	self.Entities = {}
	self.Identification = Identification

	return self
end

function Omega.RegisterModelFolder(self: Omega, Folder: Folder)
	print("OMEGA: REGISTERING MODEL FOLDER: "..Folder.Name)
	self.ModelFolder = Folder
end

function Omega.RegisterConfigurationFolder(self: Omega, Configuration: Configuration)
	print("OMEGA: REGISTERING CONFIGURATION FOLDER: "..Configuration.Name)
	self.ConfigurationFolder = Configuration
end

function Omega.NPC(self: Omega, Name: string, SpawnCFrame: CFrame?): Typings.NPC
	return NPC.create(self, Name, SpawnCFrame)
end

return Omega.create()
