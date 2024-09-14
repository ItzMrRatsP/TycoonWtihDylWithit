local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Global = require(ReplicatedStorage.Shared.Global)

local Character = require(ServerStorage.Server.Player.Components.Character)
local Player = require(ServerStorage.Server.Player.Components.Player)

local function characerLife()
	-- insert logic for system here
	Character.onAdded:Connect(function(entity, comp)
		local player = Player.get(entity)
		if not player then
			warn("no player for character how is that possible?")
			return
		end

		local hum = comp.instance:WaitForChild("Humanoid")
		hum.Died:Connect(function()
			player:LoadCharacter()
		end)
	end)
end

return Global.Schedules.Boot.job(characerLife)
