local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Global = require(ReplicatedStorage.Shared.Global)

-- local Janitor = require(ReplicatedStorage.Packages.Janitor)

local PlayerEntityTracker =
	require(ReplicatedStorage.Shared.Modules.PlayerEntityTracker)

local Component = {}

function Component:add(entity, playerInstance: Player)
	PlayerEntityTracker.add(entity, playerInstance)

	return playerInstance
end

-- function Component:remove(_, comp)
-- 	comp.janitor:Destroy()
-- end

return Global.World.factory(Global.InjectLifecycleSignals(Component))