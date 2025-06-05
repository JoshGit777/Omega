--!strict
local RunService = game:GetService("RunService")

local Omega = {
	Loaded = nil,
}
Omega.__index = Omega

local NPC = require(script:WaitForChild("NPC"))
local Typings = require(script:WaitForChild("Typings"))
local Identification = require(script:WaitForChild("Identification"))

type Omega = Typings.Omega

--[=[
@class Omega
The main Omega API.
]=]

--- @prop ConfigurationFolder Configuration
--- @within Omega
--- The configuration folder assosiated with Omega

--- @prop ModelFolder Folder
--- @within Omega
--- The model folder assosiated with Omega

--- @prop Entities {NPC}
--- @within Omega
--- List of NPCs loaded

--- @prop Identification Identification
--- @within Omega
--- The identification (hashing) module

--- @prop EntityFolder Folder
--- @within Omega
--- The folder containing all the entities


function Omega.create(): Omega
	if Omega.Loaded then
		return Omega.Loaded
	end

	local self: Omega = setmetatable({} :: any, Omega)

	if RunService:IsClient() then
		return self
	end

	self.Entities = {}
	self.Identification = Identification

	self.EntityFolder = Instance.new("Folder")
	self.EntityFolder.Name = "NPCS"
	self.EntityFolder.Parent = workspace

	return self
end

--[=[ 
Sets the model folder to the provided folder
@param Folder Folder
]=]
function Omega.RegisterModelFolder(self: Omega, Folder: Folder)
	print("OMEGA: REGISTERING MODEL FOLDER: "..Folder.Name)
	self.ModelFolder = Folder
end

--[=[
Sets the configuration folder to the provided
@param Configuration Configuration
]=]
function Omega.RegisterConfigurationFolder(self: Omega, Configuration: Configuration)
	print("OMEGA: REGISTERING CONFIGURATION FOLDER: "..Configuration.Name)
	self.ConfigurationFolder = Configuration
end

--[=[ 
Creates an NPC
@param Name string
@param SpawnCFrame CFrame?
@return NPC
]=]
function Omega.NPC(self: Omega, Name: string, SpawnCFrame: CFrame?): Typings.NPC
	return NPC.create(self, Name, SpawnCFrame)
end

return Omega.create()
