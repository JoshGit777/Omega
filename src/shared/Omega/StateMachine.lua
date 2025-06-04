--!strict

--[[ Default state machine, basic humanoid with physics (its basically a carbon copy of roblox's provided state machine) ]]

local OmegaModule = script.Parent
local Typings = require(OmegaModule:WaitForChild("Typings"))

local RunService = game:GetService("RunService")

local function ControllerActive(self: Typings.NPC, Controller: ControllerBase)
	return (self.ControllerManager.ActiveController == Controller and Controller.Active)
end

local function GroundControllerActive(self: Typings.NPC)
	return (self.GroundSensor.SensedPart and not ControllerActive(self, self.GroundController))
end

local function SwimControllerActive(self: Typings.NPC)
	return self.BuoyancySensor.TouchingSurface
end

local function AirControllerActive(self: Typings.NPC)
	return (self.GroundSensor.SensedPart == nil and self.LadderSensor.SensedPart == nil)
		and not (ControllerActive(self, self.AirController) or self.BuoyancySensor.TouchingSurface)
end

local function ClimbControllerActive(self: Typings.NPC)
	return (self.LadderSensor.SensedPart ~= nil) and not (ControllerActive(self, self.ClimbController))
end

local function StartStateMachine(self: Typings.NPC)
	local StateConnection = RunService.Heartbeat:Connect(function()
		local MoveDir = self.MoveDirection

		self.ControllerManager.MovingDirection = MoveDir

		if SwimControllerActive(self) then
			self.ControllerManager.ActiveController = self.SwimController
		elseif ClimbControllerActive(self) then
			self.ControllerManager.ActiveController = self.ClimbController
		elseif GroundControllerActive(self) then
			self.ControllerManager.ActiveController = self.GroundController
		elseif AirControllerActive(self) then
			self.ControllerManager.ActiveController = self.AirController
		end

		if MoveDir.Magnitude > 0 then
			self.ControllerManager.FacingDirection = MoveDir
		else
			if ControllerActive(self, self.SwimController) then
				self.ControllerManager.FacingDirection = self.ControllerManager.RootPart.CFrame.UpVector
			else
				self.ControllerManager.FacingDirection = self.ControllerManager.RootPart.CFrame.LookVector
			end
		end
	end)

	table.insert(self.Cache, StateConnection :: any)
end

return StartStateMachine
