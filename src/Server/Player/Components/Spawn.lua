local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Global = require(ReplicatedStorage.Shared.Global)

local spawn = {}

function spawn:add(entity, spawnPoint)
	-- insert constructor for component here
	print(spawnPoint)
	return spawnPoint
end

return Global.World.factory(spawn)
