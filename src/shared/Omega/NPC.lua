--!strict

local NPC = {}

local OmegaModule = script.Parent
local Typings = require(OmegaModule:WaitForChild("Typings"))
local StateMachine = require(OmegaModule:WaitForChild("StateMachine"))
local StateHandler = require(OmegaModule:WaitForChild("StateHandler"))

NPC.__index = NPC

type NPC = Typings.NPC

function NPC.create(Omega: Typings.Omega, Name: string, SpawnCFrame: CFrame?): NPC
	local self: NPC = setmetatable({} :: any, Omega)

	local ModelFolder = Omega.ModelFolder

	if not ModelFolder then
		task.wait(5)
		ModelFolder = Omega.ModelFolder
		if not ModelFolder then
			return warn("MODEL FOLDER NOT LOADED") :: any
		end
	end

	local VisualModel = ModelFolder:FindFirstChild(Name) :: Model

	if not VisualModel then
		return warn("Class Not Found") :: any
	end

	self.RootModel = Instance.new("Model")

	local _, BoundingBox = VisualModel:GetBoundingBox()

	self.RootPart = Instance.new("Part")
	if SpawnCFrame then
		self.RootPart.CFrame = SpawnCFrame
	end

	self.RootPart.Transparency = 1
	self.RootPart.Size = BoundingBox
	self.RootPart.CanCollide = true
	self.RootPart.CanQuery = false
	self.RootPart.Parent = self.RootModel

	self.ControllerManager = Instance.new("ControllerManager")

	self.GroundSensor = Instance.new("ControllerPartSensor")
	self.LadderSensor = Instance.new("ControllerPartSensor")
	self.BuoyancySensor = Instance.new("BuoyancySensor")

	self.ClimbController = Instance.new("ClimbController")
	self.GroundController = Instance.new("GroundController")
	self.AirController = Instance.new("AirController")
	self.SwimController = Instance.new("SwimController")

	self.GroundSensor.SensorMode = Enum.SensorMode.Floor
	self.GroundSensor.SearchDistance = (BoundingBox.Y / 2) + 0.5
	self.LadderSensor.SensorMode = Enum.SensorMode.Ladder
	self.LadderSensor.SearchDistance = BoundingBox.Z

	self.GroundController.GroundOffset = 0

	self.GroundController.Parent = self.ControllerManager
	self.GroundSensor.Parent = self.RootPart
	self.LadderSensor.Parent = self.RootPart
	self.BuoyancySensor.Parent = self.ControllerManager
	self.ClimbController.Parent = self.ControllerManager
	self.AirController.Parent = self.ControllerManager
	self.SwimController.Parent = self.ControllerManager

	self.ControllerManager.ActiveController = self.GroundController
	self.ControllerManager.RootPart = self.RootPart
	self.ControllerManager.GroundSensor = self.GroundSensor
	self.ControllerManager.ClimbSensor = self.LadderSensor

	self.ControllerManager.Parent = self.RootModel

	self.Cache = {}
	self.LoadedStates = {}
	self.MoveDirection = Vector3.zero

	StateHandler(self)

	self.ConfigurationModule = Omega.ConfigurationFolder:FindFirstChild(Name) :: ModuleScript

	if not self.ConfigurationModule then
		return warn("Configuration Module Not Found") :: any
	end

	self.Configuration = require(self.ConfigurationModule) :: Typings.NPCConfiguration

	self.Configuration.Functionality(self)

	if self.Configuration["CharacterStateMachine"] then
		self.Configuration.CharacterStateMachine(self)
	else
		StateMachine(self)
	end

	self.RootModel.Parent = workspace

	return self
end

function NPC.Destroy(self: NPC)
	for _, connection: thread & RBXScriptConnection in self.Cache do
		local ConnectionType = typeof(connection)

		if ConnectionType == "RBXScriptConnection" then
			connection:Disconnect()
		end

		if ConnectionType == "thread" then
			task.cancel(connection)
		end
	end

	self.RootModel:Destroy()
end

return NPC
