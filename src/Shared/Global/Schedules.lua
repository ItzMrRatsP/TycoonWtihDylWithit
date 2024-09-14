local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Sandwich = require(ReplicatedStorage.Packages.Sandwich)

export type Schedule = typeof(Sandwich.schedule())
export type Schedules = { [any]: Schedule }

local DEBUG = require(script.Parent.DebugUtil)
local Util = require(script.Parent.Util)

local Schedules: Schedules = {}

local jobFilter = Util.arrayToDict {
	"Heartbeat",
	"PostSimulation",
	"PreSimulation",
	"Stepped",
	"PreAnimation",
	"PreRender",
	"RenderStepped",
}

local debugEnabled = false
local warnFirstJob = true
local warnAnyJob = true

local i = 0
local alreadyPrinted = {}

local function createScheduleProxy(k)
	local schedule = Sandwich.schedule()

	local firstJob
	if debugEnabled and warnFirstJob then
		firstJob = schedule.job(function()
			if not alreadyPrinted[k] then
				i += 1
				alreadyPrinted[k] = true
				warn(`Schedule #{i}: "{k}"`)
			end
		end)
	end

	local proxy = {}

	if not jobFilter[k] and debugEnabled and warnAnyJob then
		function proxy.job(func, ...)
			local tb = string.split(debug.traceback("",2), "\n")[3]
			local otherFirstJob = schedule.job(function()
				warn(`{k} Job: {tb}`)
			end, firstJob)
			return schedule.job(func, ..., otherFirstJob)
		end
	end

	return setmetatable(proxy, { __index = schedule })
end -- explain this :3

setmetatable(Schedules, {
	__index = function(self, k)
		local schedule = createScheduleProxy(k)
		print(self, k)
		rawset(self, k, schedule)
		return self[k]
	end,
})

return Schedules
