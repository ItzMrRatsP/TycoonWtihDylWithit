local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Global = require(ReplicatedStorage.Shared.Global)

type map = { [string]: { string } }

local PlotTemplate = workspace:WaitForChild("PlotTemplate")
local Buttons = PlotTemplate:WaitForChild("Buttons")

local dependentMap: map = {}

for _, button: Instance in Buttons:GetChildren() do
	local dependentsAttribute: string? =
		button:GetAttribute("Dependents") :: string?
	if not dependentsAttribute then continue end

	local dependents = string.split(dependentsAttribute:gsub("%s+", ""), ",")

	for _, dependent: string in dependents do
		if not PlotTemplate:FindFirstChild(dependent, true) then
			warn("Nothing with name ", dependent, "found in Template")
			continue
		end
		local map = dependentMap[dependent]

		if not map then
			map = {}
			dependentMap[dependent] = map
		end

		table.insert(map, button.Name)
	end
end

return dependentMap
