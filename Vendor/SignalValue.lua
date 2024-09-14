local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Signal = require(ReplicatedStorage.Packages.Signal)
local TableValue = require(ReplicatedStorage.Packages.TableValue)

return function(tab: { [any]: any })
	local self = TableValue.new(tab)

	self.Signal = Signal.new()

	function self.Changed(tab, key, new, old)
		self.Signal:Fire(key, new, old)
	end

	return self
end
