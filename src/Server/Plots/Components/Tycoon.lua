local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Global = require(ReplicatedStorage.Shared.Global)
local Profiles = require(ServerStorage.Server.Player.Modules.Profiles)

local Tycoon = { Key = "TycoonData" }

Profiles.addDefaultData("PlayerData", Tycoon.Key, {})

function Tycoon:add(entity, tycoon)
	-- insert constructor for component
	return tycoon
end

return Global.World.factory(Global.InjectLifecycleSignals(Tycoon))
