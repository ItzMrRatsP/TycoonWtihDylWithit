local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local PlayerEntityTracker =
	require(ReplicatedStorage.Shared.Modules.PlayerEntityTracker)

local Money = require(ServerStorage.Server.Money.Components.Money)
local Tycoon = require(ServerStorage.Server.Plots.Components.Tycoon)

local Hookups = {}

function Hookups.claim(tycoon)
	-- for claiming money
	tycoon.claim.Touched:Connect(function(a0: BasePart)
		local money = Money.get(tycoon.owner)
		if not money then return end

		money.value += tycoon.income.money
		tycoon.income.money = 0
	end)
end

function Hookups.displayMoney(tycoon)
	tycoon.income.Signal:Connect(function(key, value): ()
		if key ~= "money" then return end

		local indicatorGui = tycoon.indicator:FindFirstChild("Gui")
		local label = indicatorGui:FindFirstChild("Label")

		label.Text = `{value}$`
	end)
end

return Hookups
