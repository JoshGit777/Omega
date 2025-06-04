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
    self.RootPart.CanCollide = false
    self.RootPart.CanQuery = false
    self.RootPart.Parent = self.RootModel
    
	self.ControllerManager = Instance.new("ControllerManager")

	self.GroundSensor = Instance.new("ControllerPartSensor")
	self.LadderSensor = Instance.new("ControllerPartSensor")
	self.BuoyancySensor = Instance.new("BuoyancySensor")

	self.ClimbController = Instance.new("ClimbController")
	self.GroundController = Instance.new("GroundController")
    self.AirController = Instance.new("AirController")
    
	self.GroundSensor.SensorMode = Enum.SensorMode.Floor
    self.GroundSensor.SearchDistance = BoundingBox.Y + 0.1
	self.LadderSensor.SensorMode = Enum.SensorMode.Ladder
    self.LadderSensor.SearchDistance = BoundingBox.Z

    self.GroundController.GroundOffset = BoundingBox.Y
    
    self.GroundController.Parent = self.ControllerManager
    self.GroundSensor.Parent = self.ControllerManager
    self.LadderSensor.Parent = self.ControllerManager
    self.BuoyancySensor.Parent = self.ControllerManager
    self.ClimbController.Parent = self.ControllerManager
    
    self.ControllerManager.ActiveController = self.GroundController
    self.ControllerManager.RootPart = self.RootPart
    self.ControllerManager.GroundSensor = self.GroundSensor
    self.ControllerManager.ClimbSensor = self.LadderSensor

    self.ControllerManager.Parent = self.RootModel

    StateMachine(self)
    
    self.ConfigurationModule = Omega.ConfigurationFolder:FindFirstChild(Name) :: ModuleScript

    if not self.ConfigurationModule then
        return warn("Configuration Module Not Found") :: any
    end

    self.Configuration = require(self.ConfigurationModule) :: Typings.NPCConfiguration

    self.Configuration.StateMachine(self)

	return self
end

function NPC.Destroy(self:NPC)
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
