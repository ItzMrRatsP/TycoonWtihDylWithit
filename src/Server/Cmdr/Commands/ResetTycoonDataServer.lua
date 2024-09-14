local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local PlayerEntityTracker =
	require(ReplicatedStorage.Shared.Modules.PlayerEntityTracker)

local Tycoon = require(ServerStorage.Server.Plots.Components.Tycoon)

return function(_, players: { Player })
	for _, player in players do
		local playerEntity = PlayerEntityTracker.get(player)
		if not playerEntity then continue end

		local tycoondata = Tycoon.get(playerEntity)
		if not tycoondata then continue end

		table.clear(tycoondata.saved)
	end

	return `Successfully removed tycoon data for {players}.`
end
