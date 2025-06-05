--!strict

local NPC = {}

local OmegaModule = script.Parent
local Typings = require(OmegaModule:WaitForChild("Typings"))
local StateMachine = require(OmegaModule:WaitForChild("StateMachine"))
local StateHandler = require(OmegaModule:WaitForChild("StateHandler"))

NPC.__index = NPC

type NPC = Typings.NPC

--[=[
@class NPC
The NPC class. This is where all the entities are created and setup, with the framework, etc.
]=]

--- @prop RootModel Model
--- @within NPC
--- The model that the npc is loaded on
--- Basically the npc in the game world NOTE THAT ON THE SERVER THE RENDER MODEL WILL NOT EXIST

--- @prop RootPart BasePart
--- @within NPC
--- The npc's root part

--- @prop ControllerManager ControllerManager
--- @within NPC
--- the NPC's controller manager, which is basically the Humanoid

--- @prop GroundSensor ControllerPartSensor
--- @within NPC
--- The NPC's ground sensor, which is used to detect the floor of the NPC

--- @prop LadderSensor ControllerPartSensor
--- @within NPC
--- The NPC's ladder sensor, which is used to detect the truss the NPC is climbing on

--- @prop GroundController GroundController
--- @within NPC
--- The NPC's ground controller, which is used to handle ground movement

--- @prop ClimbController ClimbController
--- @within NPC
--- The NPC's climb controller, which is used to handle climbing

--- @prop AirController AirController
--- @within NPC
--- The NPC's air controller, which is used to handle air movement

--- @prop SwimController SwimController
--- @within NPC
--- The NPC's swim controller, which is used to handle swim movement

--- @prop Configuration NPCConfiguration
--- @within NPC
--- The configuration file of the NPC

--- @prop ConfigurationModule ModuleScript
--- @within NPC
--- The configuration Module Script that is used to get Configuration

--- @prop State State
--- @within NPC
--- The current state of the NPC

--- @prop MoveDirection Vector3
--- @within NPC
--- The move direction of the NPC
--- Only used if state machine is not overridden

--- @prop LoadedStates {State}
--- @within NPC
--- The states that are loaded

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

	--[[ Runs user functionality ]]
	self.Configuration.Functionality(self)

	if self.Configuration["CharacterStateMachine"] then
		self.Configuration.CharacterStateMachine(self)
	else
		StateMachine(self)
	end

	self.RootModel.Parent = workspace

	return self
end

--[=[ 
Destroys the selected NPC, and clears the cache
]=]
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
