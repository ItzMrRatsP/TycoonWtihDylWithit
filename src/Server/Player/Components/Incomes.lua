local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Global = require(ReplicatedStorage.Shared.Global)

local income = {}

function income:add(entity, playerIncome: number)
	return playerIncome
end

return Global.World.factory(income)
