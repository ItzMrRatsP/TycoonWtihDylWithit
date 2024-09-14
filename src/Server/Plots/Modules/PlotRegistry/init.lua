--!strict
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")
local TweenService = game:GetService("TweenService")

local Global = require(ReplicatedStorage.Shared.Global)

local TableValue = require(ReplicatedStorage.Packages.TableValue)
-- local Janitor = require(ReplicatedStorage.Packages.Janitor)

local GamepassHandler =
	require(ServerStorage.Server.Monetization.Modules.GamepassHandler)
local Spawn = require(ServerStorage.Server.Player.Components.Spawn)
local Tycoon = require(ServerStorage.Server.Plots.Components.Tycoon)

local SignalValue = require(ReplicatedStorage.Vendor.SignalValue)
local Types = require(ServerStorage.Server.Plots.Modules.Types)

local Buttons = require(script.Buttons)
local Hookups = require(script.Hookups)

local PlotRegistry = {}
PlotRegistry.cache = {}

local tycoonStorage = Instance.new("Folder")
tycoonStorage.Name = "TycoonStorage"
tycoonStorage.Parent = ReplicatedStorage

local tycoonCounter = 0

PlotRegistry.validate = require(script.Validate)

function PlotRegistry.registerIDs(tycoon: Types.Tycoon)
	for _, v in tycoon.buttons:GetChildren() do
		tycoon.idToInstance[v.Name] = v
	end

	for _, v in tycoon.models:GetChildren() do
		tycoon.idToInstance[v.Name] = v
	end
end

function PlotRegistry.getPlotGamepasses(tycoon)
	local gamepassCosts = {}

	for _, v in tycoon.buttons:GetChildren() do
		if not v:GetAttribute("Currency") then continue end
		if not v:GetAttribute("Cost") then continue end

		if v:GetAttribute("Currency") ~= "Robux" then continue end
		table.insert(gamepassCosts, v:GetAttribute("Cost"))
	end

	return gamepassCosts
end

function PlotRegistry.register(plotModel: Model)
	plotModel.Name = "Tycoon" .. tycoonCounter
	tycoonCounter += 1 -- adds 1 to the counter.

	local tycoon: Types.Tycoon? = PlotRegistry.validate(plotModel)
	if not tycoon then return end

	local repVersion = Instance.new("Folder")
	repVersion.Name = plotModel.Name
	repVersion.Parent = tycoonStorage

	tycoon.owner = nil
	tycoon.income = SignalValue { perSecond = 1, money = 0 }

	tycoon.model = plotModel
	tycoon.repVersion = repVersion
	tycoon.idToInstance = {}

	PlotRegistry.registerIDs(tycoon)

	tycoon.gamepassCache =
		GamepassHandler.getPrices(PlotRegistry.getPlotGamepasses(tycoon))

	tycoon.buttonData, tycoon.buttonIdLUT = Buttons.registerButtons(tycoon)
	PlotRegistry.reset(tycoon)
	PlotRegistry.hookUp(tycoon)

	PlotRegistry.cache[plotModel] = tycoon :: Types.Tycoon
end

function PlotRegistry.hookUp(tycoon: Types.Tycoon)
	Hookups.claim(tycoon)
	Hookups.displayMoney(tycoon)

	Buttons.hookUp(tycoon)
end

function PlotRegistry.loadData(tycoon, data)
	-- load data
	tycoon.saved = data
	for _, id in data do
		local buttonData = tycoon.buttonIdLUT[id]
		if not buttonData then
			warn("erm, where is this button data")
			continue
		end

		buttonData.owned = true
	end

	for _, id in data do
		local buttonData = tycoon.buttonIdLUT[id]
		if not buttonData then
			warn("erm, where is this button data")
			continue
		end

		buttonData.activate(tycoon)
	end
end

function PlotRegistry.claim(tycoon: Types.Tycoon, entity, data)
	PlotRegistry.reset(tycoon)
	tycoon.owner = entity
	Spawn.add(entity, tycoon.spawn)
	PlotRegistry.loadData(tycoon, data)
	Tycoon.add(entity, tycoon)
end

function PlotRegistry.reset(tycoon: Types.Tycoon)
	for id, button: Types.ButtonData in tycoon.buttonData do
		button.deactivate(tycoon)
	end
	Tycoon.remove(tycoon.owner)
	tycoon.owner = nil
end

return PlotRegistry
