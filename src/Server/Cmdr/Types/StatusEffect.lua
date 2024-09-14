local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Global = require(ReplicatedStorage.Shared.Global)

return function(registry)
	registry:RegisterType(
		"statusEffect",
		registry.Cmdr.Util.MakeEnumType(
			"StatusEffect",
			{ "Defense", "NoJump", "Silenced", "Slowed" }
		)
	)
end
