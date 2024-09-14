local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Global = require(ReplicatedStorage.Shared.Global)

local PlayerEntityTracker =
	require(ReplicatedStorage.Shared.Modules.PlayerEntityTracker)

local Character = require(ServerStorage.Server.Player.Components.Character)
local GamePasses =
	require(ServerStorage.Server.Monetization.Components.GamePasses)
local Incomes = require(ServerStorage.Server.Player.Components.Incomes)
local Money = require(ServerStorage.Server.Money.Components.Money)
local Player = require(ServerStorage.Server.Player.Components.Player)
local Profile = require(ServerStorage.Server.Player.Components.Profile)

local Profiles = require(ServerStorage.Server.Player.Modules.Profiles)

-- All gamepasses here

local productIds = {
	[1875948901] = "MonaLisaPainting",
	[874239838] = "InfMoney",
	[874459383] = "doubleIncome",
}

local function ListenCharacterAdded(entity, playerInstance)
	local addedPartial = function(character)
		Character.add(entity, character)
	end

	if playerInstance.Character then addedPartial(playerInstance.Character) end
	playerInstance.CharacterAdded:Connect(addedPartial)

	playerInstance.CharacterRemoving:Connect(function()
		Character.remove(entity)
	end)
end

local ProfileStore = nil
local function InitPlayer(playerInstance)
	local playerEntity = Global.World.entity()

	if not ProfileStore then return end

	local profile = Profile.add(playerEntity, playerInstance, ProfileStore)

	if not profile then return end

	Player.add(playerEntity, playerInstance)
	GamePasses.add(playerEntity, productIds)
	Incomes.add(playerEntity, playerInstance)
	Money.add(playerEntity, profile)

	ListenCharacterAdded(playerEntity, playerInstance)
end

local function ListenPlayerAdded()
	-- Global.DEBUG("SetupPlayers Booted!")

	ProfileStore = Profiles.getProfileStore("PlayerData")

	for _, playerInstance in Players:GetPlayers() do
		InitPlayer(playerInstance)
	end

	Players.PlayerAdded:Connect(InitPlayer)
	Players.PlayerRemoving:Connect(function(playerInstance)
		local playerEntity = PlayerEntityTracker.get(playerInstance)
		if playerEntity then Player.remove(playerEntity) end
	end)
end

return Global.Schedules.Boot.job(ListenPlayerAdded)
