local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Global = require(ReplicatedStorage.Shared.Global)

local Tag = "RGBText"
local Speed = 5

local function boot()
	local Texts = CollectionService:GetTagged(Tag) -- Checks for every UI!

	for _, label in Texts do
		local t = tick() % Speed / Speed
		label.TextColor3 = Color3.fromHSV(t, 1, 1)
	end
end

return Global.Schedules.RenderStepped.job(boot)
