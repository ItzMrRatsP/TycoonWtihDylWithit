local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Global = require(ReplicatedStorage.Shared.Global)

local Cmdr = require(ReplicatedStorage:WaitForChild("CmdrClient"))

return Global.Schedules.Boot.job(function()
	Cmdr:SetActivationKeys { Enum.KeyCode.F2 }
end)
