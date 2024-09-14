local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")

local Global = require(ReplicatedStorage.Shared.Global)

Global.Util.requireDescendantsIgnoreClient(ReplicatedStorage.Shared)
Global.Util.requireDescendants(ServerStorage.Server)

Global.Schedules.Init.start()
Global.Schedules.Boot.start()

for scheduleName, schedule in Global.Schedules :: any do
	pcall(function()
		RunService[scheduleName]:Connect(schedule.start)
	end)
end
