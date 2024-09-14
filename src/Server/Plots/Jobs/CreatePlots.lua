local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Global = require(ReplicatedStorage.Shared.Global)
local Player = require(ServerStorage.Server.Player.Components.Player)
local PlotRegistry = require(ServerStorage.Server.Plots.Modules.PlotRegistry)

local PLAYERS_PER_SERVER = Players.MaxPlayers -- // Max players for server
local PLOT_OFFSET = 1e2

local function makePlot(plotTemplate, plotLocationRef) end

local function PlotCreator()
	-- insert logic for system here
	local PlotTemplate = workspace:FindFirstChild("PlotTemplate")
	if not PlotTemplate then
		warn("No Plot Template found in workspace.")
		return
	end

	PlotTemplate.Parent = ReplicatedStorage

	for i = 1, PLAYERS_PER_SERVER do
		local cf = CFrame.new(i * PLOT_OFFSET, 0, 0)

		local plot = PlotTemplate:Clone()
		plot:PivotTo(cf)
		plot.Parent = workspace
		PlotRegistry.register(plot)
	end

	-- local makePlotPartial = Global.Util.partial(makePlot, PlotTemplate)
	-- CollectionService:GetInstanceAddedSignal(PLOT_TAG):Connect(makePlotPartial)

	-- for _, plotRef in CollectionService:GetTagged(PLOT_TAG) do
	-- 	makePlotPartial(plotRef)
	-- end
end

return Global.Schedules.Init.job(PlotCreator)
