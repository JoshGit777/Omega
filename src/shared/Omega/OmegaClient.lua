local OmegaModule = script.Parent

local Remotes = OmegaModule:WaitForChild("Remotes")

local ClientRemotes = require(Remotes:WaitForChild("client"))

local Workspace = game:GetService("Workspace")

local NPCS = Workspace:WaitForChild("NPCS") :: Folder

local ModelFolder = ClientRemotes.GetModelFolder.Invoke()

local ModelRendered = {}

local RenderQuene = {}

local RENDERCYCLERATE = 2

print("OMEGA: LOADED CLIENT")

local function ConfigureRenderModel(Model: Model)
	local FoundHumanoid = Model:FindFirstChildOfClass("Humanoid")

	if FoundHumanoid then
		FoundHumanoid.EvaluateStateMachine = false
	end

	for _, basePart: BasePart in pairs(Model:GetDescendants() :: any) do
		if basePart:IsA("BasePart") then
			basePart.Massless = false
			basePart.CanCollide = false
			basePart.CanTouch = false
		end
	end
end

local function RenderModel(Model: Model)
	if Model:FindFirstChild("RenderModel") then
		return nil
	end
    
    print("rendering " .. tostring(Model.Name))

	table.insert(RenderQuene, Model)

	local Class = Model:GetAttribute("Class")

	local FoundModel = ModelFolder:FindFirstChild(Class) :: Model

	local ModelTable = ModelFolder:GetChildren()

	if not FoundModel then
		FoundModel = ModelTable[1]:Clone()
	else
		FoundModel = FoundModel:Clone()
	end

	ConfigureRenderModel(FoundModel)

	local RenderPrimary = FoundModel.PrimaryPart

	local ModelPrimary = Model.PrimaryPart

	if ModelPrimary then
		RenderPrimary.CFrame = ModelPrimary.CFrame

		FoundModel.Name = "RenderModel"

		local RenderWeld = Instance.new("WeldConstraint")
		RenderWeld.Part0 = ModelPrimary
		RenderWeld.Part1 = RenderPrimary
		RenderWeld.Name = "RenderWeld"
		RenderWeld.Parent = Model

		local ModelIndex = table.find(RenderQuene, Model)

		table.remove(RenderQuene, ModelIndex)
		table.insert(ModelRendered, Model)

		FoundModel.Parent = Model
		return nil
	else
		local ModelIndex = table.find(RenderQuene, Model)

		table.remove(RenderQuene, ModelIndex)
		return nil
	end
end

task.spawn(function()
	while true do
		task.wait(RENDERCYCLERATE)

		for _, Model in pairs(NPCS:GetChildren()) do
			local FoundRenderQuene = table.find(RenderQuene, Model)
			local FoundModel = table.find(ModelRendered, Model)

			if not FoundRenderQuene and not FoundModel then
				RenderModel(Model)
			end
		end
	end
end)

NPCS.ChildAdded:Connect(function()
	for _, Model in pairs(NPCS:GetChildren()) do
		local FoundRenderQuene = table.find(RenderQuene, Model)
		local FoundModel = table.find(ModelRendered, Model)

		if not FoundRenderQuene and not FoundModel then
			RenderModel(Model)
		end
	end
end)

return { true }
