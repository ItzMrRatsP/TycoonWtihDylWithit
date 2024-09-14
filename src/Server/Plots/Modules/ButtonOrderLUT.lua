local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Global = require(ReplicatedStorage.Shared.Global)

local defaultTycoon = workspace:FindFirstChild("PlotTemplate")
local buttons = defaultTycoon.Buttons:GetChildren() :: { BasePart }

local queue = {}
local visited = {}
local closed = {}

local buttonData = Global.Util.filter_map(buttons, function(k, button)
	local currencyAttribute: string? =
		button:GetAttribute("Currency") :: string?
	local dependentsAttribute = button:GetAttribute("Dependents") or {}

	if not currencyAttribute then return end
	if currencyAttribute == "Robux" then return end

	local dependents = string.split(dependentsAttribute:gsub("%s+", ""), ",")

	return {
		id = button.Name,
		dependents = dependents,
	}
end)

local lut = {}

for _, v in buttonData do
	lut[v.id] = v
end

for _, v in buttonData do
	v.order = 1
	table.insert(queue, v)
end

while #queue > 0 do
	local cur = table.remove(queue, 1)

	if visited[cur] then continue end

	visited[cur] = true
	table.insert(closed, cur)

	for _, id: string in cur.dependents do
		local but = lut[id]
		if not but then continue end

		but.order = cur.order + 1
		table.insert(queue, but)
	end

	task.wait()
end

table.sort(closed, function(a, b)
	return a.order < b.order
end)

local ret = Global.Util.arrToOrderLUT(Global.Util.map(closed, function(v)
	return v.id
end))

return ret
