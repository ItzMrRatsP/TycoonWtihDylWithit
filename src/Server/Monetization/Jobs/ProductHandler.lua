--!strict
--!native

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Global = require(ReplicatedStorage.Shared.Global)

local Player = require(ServerStorage.Server.Player.Components.Player)
local PlayerEntityTracker =
	require(ReplicatedStorage.Shared.Modules.PlayerEntityTracker)
local Products =
	require(ServerStorage.Server.Monetization.Components.GamePasses)

local function Boot()
	MarketplaceService.ProcessReceipt = function(
		receipt
	): Enum.ProductPurchaseDecision
		local productId = receipt.ProductId
		local getPlayerfromId = Players:GetPlayerByUserId(receipt.PlayerId)

		if not getPlayerfromId then
			return Enum.ProductPurchaseDecision.NotProcessedYet
		end

		local entity = PlayerEntityTracker.get(getPlayerfromId)
		Products.Success:Fire(entity, productId)

		return Enum.ProductPurchaseDecision.PurchaseGranted
	end
end

return Global.Schedules.Boot.job(
	Boot,
	require(ServerStorage.Server.Player.Jobs.BootPlayers)
)
