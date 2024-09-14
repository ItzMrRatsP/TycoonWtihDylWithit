local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local GamePasses =
	require(ServerStorage.Server.Monetization.Components.GamePasses)
local Global = require(ReplicatedStorage.Shared.Global)
local Player = require(ServerStorage.Server.Player.Components.Player)
local Signal = require(ReplicatedStorage.Packages.Signal)
local TableValue = require(ReplicatedStorage.Packages.TableValue)

local Profiles = require(ServerStorage.Server.Player.Modules.Profiles)

local Money = {}
Money.Key = "MoneyData" -- we like money
Money.Changed = Signal.new()

Profiles.addDefaultData("PlayerData", Money.Key, {
	value = 0,
})

function Money:add(entity, profile)
	-- insert constructor for component here
	local moneyData = TableValue.new(
		profile.Data[self.Key],
		function(t, key, new, old)
			if new == old then return end
			Money.Changed:Fire(entity, new)
		end
	)

	local product = GamePasses.get(entity)
	local player = Player.get(entity)

	if product.InfMoney then player:SetAttribute("InfMoney", true) end

	return moneyData
end

return Global.World.factory(Global.InjectLifecycleSignals(Money))
