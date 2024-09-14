local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Global = require(ReplicatedStorage.Shared.Global)
local Player = require(ServerStorage.Server.Player.Components.Player)

local Money = require(ServerStorage.Server.Money.Components.Money)

local ATTRIBUTE_NAME = "Money"

local function onBooted()
	-- very cool
	Money.onAdded:Connect(function(entity, comp)
		-- Add infinite money gamepass:
		local player = Player.get(entity)
		player:SetAttribute(ATTRIBUTE_NAME, comp.value) -- tada
	end)

	Money.Changed:Connect(function(e, value)
		local player = Player.get(e)
		player:SetAttribute(ATTRIBUTE_NAME, value)
	end)
end

return Global.Schedules.Boot.job(
	onBooted,
	require(ServerStorage.Server.Player.Jobs.BootPlayers)
)
