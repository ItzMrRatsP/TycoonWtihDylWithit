local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
-- local ServerStorage = game:GetService("ServerStorage")

local Global = require(ReplicatedStorage.Shared.Global)

Global.Util.requireDescendants(ReplicatedStorage.Shared)
Global.Util.requireDescendants(ReplicatedStorage.Client)

Global.Schedules.Init.start()
Global.Schedules.Boot.start()

for scheduleName, schedule in Global.Schedules :: any do
	pcall(function()
		RunService[scheduleName]:Connect(schedule.start)
	end)
end
