local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Omega = require(Shared:WaitForChild("Omega"))
local Configurations = ServerStorage:WaitForChild("OmegaConfigurations")
local Models = ReplicatedStorage:WaitForChild("NPCModels")

Omega:RegisterConfigurationFolder(Configurations)
Omega:RegisterModelFolder(Models)
Omega:NPC("Bob", CFrame.new(0, 20, 0))

while task.wait(0.42) do
    Omega:NPC("Bob", CFrame.new(0, 20, 0))
end
