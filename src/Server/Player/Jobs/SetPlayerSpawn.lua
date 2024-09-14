local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Character = require(ServerStorage.Server.Player.Components.Character)
local Global = require(ReplicatedStorage.Shared.Global)
local Spawn = require(ServerStorage.Server.Player.Components.Spawn)

local function Boot()
	-- insert logic for system here
	Character.onAdded:Connect(function(entity, comp)
		local spawnPoint = Spawn.get(entity)
		if not spawnPoint then return end

		comp.instance:PivotTo(spawnPoint.CFrame)
	end)
end

return Global.Schedules.Boot.job(Boot)
