local Identification = {
    Loaded = nil
}
Identification.__index = Identification

local OmegaModule = script.Parent
local Typings = require(OmegaModule:WaitForChild("Typings"))

type Identification = Typings.Identification

function Identification.create(): Identification
    if not Identification.Loaded then
        return Identification.Loaded
    end

    local self:Identification = setmetatable({}::any, Identification)

    self.Registered = {}
    self.LastID = -1

    return self
end

function Identification.Register(self:Identification, Value:any)
    local IDValue = self.LastID + 1
    self.Registered[IDValue] = Value
end

function Identification.Get(self:Identification, ID:number)
    return self.Registered[ID]
end

return Identification.create()