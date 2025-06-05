local Identification = {
    Loaded = nil
}
Identification.__index = Identification

local OmegaModule = script.Parent
local Typings = require(OmegaModule:WaitForChild("Typings"))

type Identification = Typings.Identification

--[=[ 
@class Identification
A major problem with developing NPC AI, in my personal opinion, is figuring out which npc is associated with which entity.
So we have this, to figure out what number is assosiated with what.
]=]

--- @prop Registered {any}
--- @within Identification
--- The registered objects in Identification

--- @prop LastID number
--- @within Identification
--- The last ID assosiated assigned
--- @private


function Identification.create(): Identification
    if not Identification.Loaded then
        return Identification.Loaded
    end

    local self:Identification = setmetatable({}::any, Identification)

    self.Registered = {}
    self.LastID = -1

    return self
end

--[=[ 
    Registers an object to the module
    @param Value any
    @return any
]=]
function Identification.Register(self:Identification, Value:any)
    local IDValue = self.LastID + 1
    self.Registered[IDValue] = Value
    return IDValue
end

--[=[
    Gets an object based on the ID returned from :Register()
    @param ID number
    @return any
]=]

function Identification.Get(self:Identification, ID:number)
    return self.Registered[ID]
end

return Identification.create()