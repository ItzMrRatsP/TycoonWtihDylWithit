local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local GamePasses =
	require(ServerStorage.Server.Monetization.Components.GamePasses)
local Global = require(ReplicatedStorage.Shared.Global)
local Tycoon = require(ServerStorage.Server.Plots.Components.Tycoon)

local function boot()
	-- insert logic for system here
	task.spawn(function()
		while task.wait(1) do -- e
			for entity, components in Global.World.query { Tycoon } do
				local tycoon = components[Tycoon]
				if not tycoon.income.perSecond then continue end
				local gamepasses = GamePasses.get(tycoon.owner)
				if not gamepasses then continue end

				tycoon.income.money += if gamepasses.doubleIncome
					then tycoon.income.perSecond * 2
					else tycoon.income.perSecond
			end
		end
	end)
end

return Global.Schedules.Boot.job(boot)
