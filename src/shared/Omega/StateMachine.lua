--!strict

local OmegaModule = script.Parent
local Typings = require(OmegaModule:WaitForChild("Typings"))

local RunService = game:GetService("RunService")

local function StartStateMachine(self:Typings.NPC)
    local StateConnection = RunService.Heartbeat:Connect(function()
        local GroundSensorActive = self.GroundSensor.SensedPart
        local ClimbSensorActive = self.LadderSensor.SensedPart

        if GroundSensorActive then
            self.ControllerManager.ActiveController = self.GroundController
        end

        if ClimbSensorActive then
            self.ControllerManager.ActiveController = self.ClimbController
        end

        if (not GroundSensorActive) and (not ClimbSensorActive) then
            self.ControllerManager.ActiveController = self.AirController
        end
    end)

    table.insert(self.Cache, StateConnection :: any)

end

return StartStateMachine