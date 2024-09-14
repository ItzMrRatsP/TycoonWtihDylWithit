local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local PlayerEntityTracker =
	require(ReplicatedStorage.Shared.Modules.PlayerEntityTracker)

local Money = require(ServerStorage.Server.Money.Components.Money)

return function(_, players: { Player }, amount: number?)
	for _, player in players do
		local playerEntity = PlayerEntityTracker.get(player)
		if playerEntity then
			local money = Money.get(playerEntity)
			if money then money.value = amount or 0 end
		end
	end

	return `Successfully set money to {amount} for {players}.`
end
