local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Global = require(ReplicatedStorage.Shared.Global)

local Player = require(ServerStorage.Server.Player.Components.Player)
local PlotRegistry = require(ServerStorage.Server.Plots.Modules.PlotRegistry)
local Tycoon = require(ServerStorage.Server.Plots.Components.Tycoon)

local function TycoonLife()
	-- insert logic for system here
	Tycoon.onAdded:Connect(function(entity, comp)
		local player = Player.get(entity)
		if not player then return end

		player:LoadCharacter()
	end)

	Tycoon.onRemoved:Connect(function(entity, comp)
		local player = Player.get(entity)
		if not player then return end

		PlotRegistry.reset(comp)
	end)
end

return Global.Schedules.Boot.job(TycoonLife)
