local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Global = require(ReplicatedStorage.Shared.Global)

local Janitor = require(ReplicatedStorage.Packages.Janitor)

local CharacterEntityTracker =
	require(ReplicatedStorage.Shared.Modules.CharacterEntityTracker)

local Character = {}

function Character:add(entity, characterInstance)
	CharacterEntityTracker.add(entity, characterInstance)

	return {
		janitor = Janitor.new(),
		instance = characterInstance,
	}
end

function Character:remove(_, comp)
	comp.janitor:Destroy()
end

return Global.World.factory(Global.InjectLifecycleSignals(Character))
