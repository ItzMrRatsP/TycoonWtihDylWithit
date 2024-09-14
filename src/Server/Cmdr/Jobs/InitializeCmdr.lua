local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Global = require(ReplicatedStorage.Shared.Global)

local Cmdr = require(ReplicatedStorage.Packages.Cmdr)

Cmdr:RegisterDefaultCommands()
Cmdr:RegisterHooksIn(ServerStorage.Server.Cmdr.Hooks)
Cmdr:RegisterTypesIn(ServerStorage.Server.Cmdr.Types)
Cmdr:RegisterCommandsIn(ServerStorage.Server.Cmdr.Commands)

return Global.Schedules.Boot.job(function()

	-- Cmdr:RegisterCommandsIn(ServerStorage.Server.Cmdr.Handlers)
end)
