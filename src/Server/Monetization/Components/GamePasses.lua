local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Global = require(ReplicatedStorage.Shared.Global)
local Player = require(ServerStorage.Server.Player.Components.Player)
local Signal = require(ReplicatedStorage.Packages.Signal)

local Products = {}
Products.Success = Signal.new() -- On Success

function Products:add(entity, productIds: { number })
	local lut = {}
	local player = Player.get(entity)

	for id, name in productIds do
		lut[name] = MarketplaceService:UserOwnsGamePassAsync(player.UserId, id)
	end

	return lut
end

return Global.World.factory(Products)
