local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Global = require(ReplicatedStorage.Shared.Global)
local Profile = require(ServerStorage.Server.Player.Components.Profile)

local PlotRegistry = require(ServerStorage.Server.Plots.Modules.PlotRegistry)
local Tycoon = require(ServerStorage.Server.Plots.Components.Tycoon)

local function newProfile(entity, comp)
	local tycoon = Global.Util.pickRandom(
		Global.Util.filter(PlotRegistry.cache, function(_, v)
			return not v.owner
		end)
	)
	if not tycoon then
		warn("something went horribly wrong...")
		return
	end

	PlotRegistry.claim(tycoon, entity, comp.Data[Tycoon.Key])
end

local function boot()
	-- insert logic for system here
	for entity, components in Global.World.query { Profile } do
		newProfile(entity, components[Profile])
	end

	Profile.onAdded:Connect(newProfile)
end

return Global.Schedules.Boot.job(
	boot,
	require(ServerStorage.Server.Player.Jobs.BootPlayers)
)
